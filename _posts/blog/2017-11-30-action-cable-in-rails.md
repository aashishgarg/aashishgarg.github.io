---
layout: post
share: true
title: "Action cable POC in rails"
modified: 2017-11-29T08:20:50-04:00
categories: blog
excerpt:
tags: []
image:
  feature:
date: 2017-11-29T08:20:50-04:00
---

##### A simple working demo of Action Cable 
The source code for this article is available at - [Ashish Garg Github](https://github.com/aashishgarg/Action-cable)

ActionCable is a framework for real-time configuration over web sockets.
It provides both client-side (JavaScript) and server-side (Ruby) code and so you can craft sockets-related 
functionality like any other part of your Rails application.

* Create a rails application
```
rails new ActionCableUploader
```

* For authentication add gem - clearance and jquery
```ruby
gem 'clearance', '~> 1.16'
gem 'jquery-rails'
```
Add **//= require jquery3** in _application.js_

* Install clearance
```
bundle install
rails generate clearance:install
```
Here **User** model will get created.

* For chat messages create a **Message** model
```
rails g model Message user:belongs_to body:text
```

* Define the associations
```ruby
# models/user.rb
has_many :messages, dependent: :destroy
# models/message.rb
belongs_to :user
```

* Install migration
```
rails db:migrate
```

* Now we need add a page a from where new message will be submitted and all messages will be displayed
```
rails g controller chat index
```

* Edit the routes
```ruby
root 'chats#index'
```

* Edit the Chat controller
```ruby
class ChatsController < ApplicationController

  before_action :require_login
  
  def index
  end
end
```
Here **before_action :require_login** is used for authentication.


* For showing the logged in user details edit the layout file - 
```html
<!-- views/layouts/application.html.erb -->
<% if signed_in? %>
  Signed in as: <%= current_user.email %>
  <%= button_to 'Sign out', sign_out_path, method: :delete %>
<% else %>
  <%= link_to 'Sign in', sign_in_path %>
<% end %>

<div id="flash">
  <% flash.each do |key, value| %>
    <%= tag.div value, class: "flash #{key}" %>
  <% end %>
</div>
```

* Next we need a form to type the chat messages. There for update the chat index view file
```html
<div id="messages">
  <%= render @messages %>
</div>

<%= form_with url: '#', html: {id: 'new-message'} do |f| %>
  <%= f.label :body %>
  <%= f.text_area :body, id: 'message-body' %>
  <br>
  <%= f.submit %>
<% end %>
```

* Create a new partial - views/messages/_message.html.erb
```html
<div class="message">
  <strong><%= message.user.email %></strong> says:
  <%= message.body %>
  <br>
  <small>at <%= l message.created_at, format: :short %></small>
  <hr>
</div>
```

* Edit the index action of chat controller
```ruby
# chats_controller.rb
def index
  @messages = Message.order(created_at: :asc)
end
``` 

----------------------------------------------------------------------------------------------
### Action Cable Client side

Till here this all was the basic rails application functionality.
From here Action cable feature starts.   

* Edit the environment file
```ruby
config.action_cable.url = 'ws://localhost:3000/cable'
config.action_cable.allowed_request_origins = [ 'http://localhost:3000', 'http://127.0.0.1:3000' ]
```

* Edit routes for mounting action cable in the application
```ruby
mount ActionCable.server => '/cable'
```

* Update the layout file for adding the meta tag
```html
<!-- views/layouts/application.html.erb -->
<!-- ... -->
<%= action_cable_meta_tag %>
<%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track': 'reload' %>
<%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>
<!-- ... -->
```

* Now add a js file in the assets - app/assets/javascripts/channels/chat.js
```javascript
jQuery(document).on('turbolinks:load', function () {
    $messages = $('#messages');
    console.log($messages);
    $new_message_form = $('#new-message');
    $new_message_body = $new_message_form.find('#message-body');
    if ($messages.length > 0) {
        return App.chat = App.cable.subscriptions.create({
            channel: "ChatChannel"
        }, {
            connected: function () {
            },
            disconnected: function () {
            },
            received: function(data) {
                if (data['message']) {
                    $new_message_body.val('');
                    return $messages.append(data['message']);
                }
            },
            send_message: function(message) {
                return this.perform('send_message', {
                    message: message
                });
            }
        });
    }
});
```

**Here Channel subscription is taking place. Callbacks [connected, disconnected, received and send_message] will 
be used to actually forward the messages to the server.**

* Now we need to listen to the form submit event, prevent the default action and call the **_send_message_** method.
```javascript
jQuery(document).on('turbolinks:load', function() {
        if ($messages.length > 0) {
            return $new_message_form.submit(function(e) {
                var $this, message_body;
                $this = $(this);
                message_body = $new_message_body.val();
                if ($.trim(message_body).length > 0) {
                    App.chat.send_message(message_body);
                }
                e.preventDefault();
                return false;
            });
        }
    });
```

### Action Cable Server side

* Create a new file - app/channels/chat_channel.rb that will process the messages sent from the client side.
```ruby
class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_channel"
  end

  def unsubscribed
  end

  def send_message(data)
    Message.create(body: data['message'])
  end
end
```

There are two callbacks here that are run automatically: **_subscribed_** and **_unsubscribed_**.
**_send_message_ is the methos that is called bt the following line of code in our chat.js**
```javascript
this.perform('send_message', {
                    message: message
                });
```
There is a problem, however: we don't have access to the Clearance's current_user method from inside the 
channel's code, therefore it is not possible to enforce authentication and associate the created message to a user.

To fix this problem, the current_user should be defined manually. 

* Now modify the file - app/channels/application_cable/connection.rb
```ruby
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_current_user
      reject_unauthorized_connection unless self.current_user
    end

    private

    def find_current_user
      if remember_token.present?
        @current_user ||= user_from_remember_token(remember_token)
      end

      @current_user
    end

    def cookies
      @cookies ||= ActionDispatch::Request.new(@env).cookie_jar
    end

    def remember_token
      cookies[Clearance.configuration.cookie_name]
    end

    def user_from_remember_token(token)
      Clearance.configuration.user_model.find_by(remember_token: token)
    end
  end
end
```

The following code simply tries to find a currently logged in user by a remember token stored in the 
cookie (the cookie's name is taken from the Clearance configuration). The user is then assiged to the 
self.current_user. If, however, the user cannot be found, we reject connection effectively disallowing 
to communicate using the channel. The connect method is called automatically each time someone tries to 
subscribe to a channel, so there nothing else we need to do here.

* Now return to the ChatChannel and tweak the send_message method a bit
```ruby
def send_message(data)
  current_user.messages.create(body: data['message'])
end
```

* Now we need to broadcast the newly received message. We can perform this task in the background using Active job.
```ruby
# models/message.rb
class Message < ApplicationRecord
  belongs_to :user

  validates :body, presence: true

  after_create_commit :broadcast_message

  private

  def broadcast_message
    MessageBroadcastJob.perform_later(self)
  end
end
```

* Create messages controller
```ruby
# app/controllers/messages_controller.rb
class MessagesController < ApplicationController
end
```

* Create background job
```ruby
# app/jobs/message_broadcast_job.rb
class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    ActionCable.server.broadcast 'chat_channel', message: render_message(message)
  end

  private

  def render_message(message)
    MessagesController.render partial: 'messages/message', locals: {message: message}
  end
end
```
