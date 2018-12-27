---
layout: post
share: true
title: "Sample Rack Application in Rails"
modified: 2017-06-06T08:20:50-04:00
categories: blog
excerpt:
tags: []
image:
  feature:
date: 2017-06-06T08:20:50-04:00
---

**Rack** is a webserver interface. It means Rack is an editable list of components that every request goes through 
in order to build the response(HTML page).

When we start (rails s), a web server is launched and receives request from browser. 
The web server then submit that request to Rack, which then processes the request and builds the response that the 
web server will send back to the client(browser).

When we create a new rails project, it comes with **23 rack middlewares**. To view - run command (**rake middleware**) at the 
root of the rails project.

#### How to use Rack

To create a middleware, you need an object that responds to (call(env)) function and returns an array that will then be 
sent to the browser. The array exactly consists of three things - 

1. Status code(200, 302, 404, ...)
2. A hash containing the header.
3. The body(Needs to be enumerable via # each)

### Lets create a rack middleware

Create new rails application - rails new racktest.
Now create a folder in app/ named middleware. Then create a file called my_middleware.rb and fill it up with -

```ruby
class MyMiddleware
  def initialize(app)
  end

  def call(env)
    [200, {"Content-Type" => "text/html"}, ["Hello Rack!"]]
  end
end
```

Now add this middleware application to the rails application in application.rb-

```ruby
  config.middleware.use "MyMiddleware"
```

Now start the server and run application in the browser.
You always get the welcome message - "Hello Rack!" whatever path you hit in the bowser.

Because Rails builds the middleware list through **ActionDispatch::MiddlewareStack**. By doing so, it adds another rule to 
the middleware: MiddlewareStack initializes every middleware by passing an argument app to the object.

The (env) variable is the current environment built for that request. Its the glue between middlewares, the only 
varaible that will be persisted. If you set something in there, other middlewares will be able to access it, even the 
controller.

The app parameter during the initialization is actually the next middleware in the chain. By not 
calling (**@app.call(env)**), rack was stopped at the very first middleware and returned our value.

Now change your code as -

```ruby
class MyMiddleware  

  def initialize(app)
    @app = app #Store the app to call it down the stack  
  end

  def call(env)
    # Initialize stuff before entering 'rails'    
    # Retrieve a connection form a pool (Redis, Memcache, etc.)    
    # Authentication/authorization/tenancy setup needs to be done before    
    # Remember, you can set stuff in env and then access it in your controller.
    # The response has the same structure as before:    
    # [200, {"Content-Type" =&gt; "text/html"}, ["Hello Rack!"]]    
    # The header is now fully populated and instead of the "Hello Rack!",    
    # the body is a full HTML page.
    # @app.call will call ActionDispatch::Static which, in turn, will call 
    #   ActiveSupport::CacheStrategy which will    
    # call Rack::Runtime and so on up to your controller/view.    

     response = @app.call(env)
    # Analytics could go here.    
    # If you want to throttle connection, you could increment it here too    

    response  
   end
end
```

And your application starts behaving normally.
Lets better understand the situation with  AUTHENTICATION AND AUTHORISATION
Now change your middleware code as -

```ruby
class MyMiddleware  

  def initialize(app)
    @app = app  #the next middleware to be called    
    @fallback = RestrictedController  
  end
  
  def call(env)
    result = catch(:restricted) do      
                @app.call(env)
             end

    if result.nil?
      @fallback.call(env)
    else      
      result    
    end  
  end
end
```

Add method in application controller -

```ruby
class ApplicationController < ActionController::Base  
  protect_from_forgery with: :exception
  def restrict!    
    throw :restricted  
  end
end
```

Add a controller - (restricted_controller)

```ruby
class RestrictedController < ActionController::Base  
  def self.call(env)
    action(:respond).call(env)
  end
  
  def respond    
    flash.alert = "Couldn't access the resource"    
    redirect_to root_url
  end
end
```

The middleware calls the class method RestrictedController.call.

In any of your controller, if you call restrict!, it will throw an error that will be caught(:restricted) by your rack application. When the error is raised, the fallback application will be called.


Thanks !!!
