---
layout: post
share: true
title: "Duplicating and Cloning objects in Ruby"
modified: 2018-07-17T08:20:50-04:00
categories: ruby
excerpt:
tags: []
image:
  feature:
date: 2018-07-17T02:20:50-04:00
---

Objects can be duplicated in ruby if we want to retain the state of an object, but perform destructice acions on another object.

```ruby
>> c = "hello"
=> "hello"
>> c.object_id
=> 70248303555860
>> c.dup.object_id
=> 70248306993184

# When the object is duplicated, destructive actions can be performed and the original object will be unchanged.

>> c = "cereal"
=> "cereal"
>> c.dup.upcase!
=> "CEREAL"
>> c
=> "cereal"
```

The clone method is similar to dup, but if you dup a frozen object, but duplicate is not frozen. If you clone a frozen object, the duplicate is frozen.

```ruby
>> dog = "fido"
=> "fido"
>> dog.freeze
=> "fido"
>> dog.dup.frozen?
=> false
>> dog.clone.frozen?
=> true
```

The freeze method prevents an object from being mutated.

```ruby
>> abc = "simple as 123"
=> "simple as 123"
>> abc.freeze
=> "simple as 123"
>> abc.upcase!
RuntimeError: can't modify frozen String
```

However, frozen objects, can be reassigned to reference other objects:

```ruby
>> var = "0 is TRUE!"
=> "0 is TRUE!"
>> var.freeze
=> "0 is TRUE!"
>> var = "recursion is cool"
=> "recursion is cool"
```
