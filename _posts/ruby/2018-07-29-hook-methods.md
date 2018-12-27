---
layout: post
share: true
title: "Hook methods in ruby"
modified: 2018-07-30T08:20:50-04:00
categories: ruby
excerpt:
tags: []
image:
  feature:
date: 2018-07-30T05:20:50-04:00
---

**Hook methods** are provided by the Ruby language that let you know about certain events such as when a class inherits from another class or when a method has been added to an object.

```ruby
class String
  def self.inherited(subclass)
    puts "#{self} was inherited by #{subclass}"
  end
end
class MyString < String; end # => String was inherited by MyString
```

###### Method related hooks

* method_missing
* method_added
* singleton_method_added
* method_removed
* singleton_method_removed
* method_undefined
* singleton_method_undefined

###### Class & Module Hooks

* inherited
* append_features
* included
* extend_object
* extended
* initialize_copy
* const_missing

###### Marshalling Hooks

* marshal_dump
* marshal_load

###### Coercion Hooks

* coerce
* induced_from
* to_xxx
