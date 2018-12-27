---
layout: post
share: true
title: "Ransack search in rails"
modified: 2016-09-29T08:20:50-04:00
categories: rails
excerpt:
tags: []
image:
  feature:
date: 2016-09-29T08:20:50-04:00
---

#### Brief

Searching any item within the application is a very common requirement. Almost all the applications require the functionality to search different items.

#### Different options

Ransack search, Solr search, Mysql search, elastic search and etc.

#### Why use Ransack

Its very simple and efficient to implement for searching in ROR.

#### Implementation

* Add gem in Gemfile

```ruby
 gem 'ransack'
``` 

* Add a new route 

```ruby
  get '/department/:department_id/items_list', to: 'departments#items_list', as: 'search_items' 
```

* Add corresponding controller action 

```ruby
  def items_list
    @items = @q = @department.items.ransack(params[:q]).results
  end 
```

* Add search form in items_list.html.erb

```
   <%= search_form_for(@q, url: search_items_path(@department), method: :get) do |f| %>
      <%= f.search_field :name_or_location_cont %>
      <%= f.submit %>
   <% end %>
```

#### Description

:name_or_location_cont is the key factor here. It specifies that item is contained in (name or location) attributes in 
item model.

#### Options

1. :name_or_location_cont -  item is contained in (name or location)
2. users_name_start -  associated model user's name starts with search item.
3. <%= link_to 'My items', search_items_path(@department, q: {user_id_eq: 1}) %>  will also work.
