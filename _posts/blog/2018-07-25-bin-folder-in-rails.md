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

* **rails** in our [rails s] command is a ruby executable.
* Ruby executable means, an executable file written in ruby code.
* When we run [rails s] an equivalent command [exec ruby bin/rails server] is executed. Which runs ruby executable 
[rails] file in bin directory of our project.
* All the files in /bin directory of a rails project are ruby executable files.
* **Binstubs** are wrapper scripts around executables, whose purpose is to prepare the environment before dispatching 
the call to the original executable.
* In Ruby world, the most common binstubs are the ones that RubyGems generates after installing a gem that contains executables. 
