---
layout: post
share: true
title: ":dynamic_method in ruby"
modified: 2018-07-31T08:20:50-04:00
categories: ruby
excerpt:
tags: []
image:
  feature:
date: 2018-07-31T02:20:50-04:00
---

Methods can be defined dynamically in ruby.
Practially I felt like implementing :dynamic_method in my application when there were some values in the database and I had to create methods(method name) depending on those values.

For example - I have a Customer model and it can be of two types - **individual/non_individual**.
So I had to make these two methods(individual?/non_individual?) available on the customer instance.

```ruby
# Methods like [individual?, non_individual?] will become available on any customer instance.
  Attribute.find_by_key('CUSTOMER_TYPE').attribute_choices.each do |attr_choice|
    define_method("#{attr_choice.value.downcase.underscore}?") { customer_type_attribute == attr_choice }
  end
```

