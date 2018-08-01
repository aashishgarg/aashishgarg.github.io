---
layout: post
share: true
title: "How ruby variables reference objects"
modified: 2018-05-13T08:20:50-04:00
categories: blog
excerpt:
tags: []
image:
  feature:
date: 2018-05-13T02:20:50-04:00
---

In general, Ruby variables hold references to objects and do not hold values. In the following example, variable_one and variable_two both reference the “object_value” object.

```ruby
variable_first = "object_value"
variable_second = variable_first
```

If the "object_value" object is mutated then both **variable_first** and **variable_second** will point to the same object.

```ruby
variable_second.concat(' updated')
>> puts variable_second
object_value updated
>> puts variable_first
object_value updated
```

When variables are reassigned, all previous references are destroyed. If the variable_second is reassigned to the object “value 2”, the old reference to “object_value updated” is broken and variable_second can only be used to send messages to the “value 2” object.

Some Ruby objects are global values are the only instance of their respective class such as true, false, and nil. Other classes make multiple objects, but there is only one per type of object. For example, the Symbol class only makes one :bob object and the Integer class only makes one 100 object. These objects are stored in variables as values, which explains why some common operations available in other programming languages are not available in Ruby. This syntax does not work:

```ruby
s = 1
s++
```

The variable s stores the value of 1, not a reference to 1, so s++ is logically equivalent to 1++. We cannot change the 1 object to the 2 object (or else we would no longer have access to the 1 object), so this syntax is invalid.

