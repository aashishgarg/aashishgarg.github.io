---
layout: post
share: true
title: "bin folder in rails"
modified: 2018-07-25T08:20:50-04:00
categories: blog
excerpt:
tags: []
image:
  feature:
date: 2018-07-25T05:20:50-04:00
---

Working in Ruby on Rails, one should have a very clear understanding about the working of [rails s] with which we start 
our server and the /bin directory created in our project.

###### Important points

* Any command(like rails s) which we run from the terminal is an executable, residing in one of the folder in load path 
of our system($PATH)
* Rails executable gets installed when we install rails gem.
* **rails** in our [rails s] command is a ruby executable.
* Ruby executable means, an executable file written in ruby code.
* When we run [rails s] an equivalent command [exec ruby bin/rails server] is executed. Which runs ruby executable 
[rails] file in bin directory of our project.
* All the files in /bin directory of a rails project are ruby executable files.
* **Binstubs** are wrapper scripts around executables, whose purpose is to prepare the environment before dispatching 
the call to the original executable.
* In Ruby world, the most common binstubs are the ones that RubyGems generates after installing a gem that contains executables. 

```ruby
# For example - 
# What happens when we run [gem install rspec-core]. Rspec ships with an executable located at [./exe/rspec] inside of t7he gem.
# After the installation, RubyGems will provide us with the following executables-

# 1. <ruby-prefix>/bin/rspec (binstub generated by RubyGems)
# 2. <ruby-prefix>/lib/ruby/gems/1.9.1/gems/rspec-core-XX.YY/exe/rspec (original)

# The generated binstub <ruby-prefix>/bin/rspec is a short Ruby script, presented in a slightly simplified form here:
 
#!/usr/bin/env ruby
require 'rubygems'

# Prepares the $LOAD_PATH by adding to it lib directories of the gem and
# its dependencies:
gem 'rspec-core'

# Loads the original executable
load Gem.bin_path('rspec-core', 'rspec')
```

* By running command **rails s**, different files in the rails get initialized in the following sequence - 
  1. Gemfile
  2. config/boot.rb
  3. config/application.rb
  4. config/environments/development.rb
  5. config/initializers/*.rb
  6. config/environment.rb
  7. config.ru