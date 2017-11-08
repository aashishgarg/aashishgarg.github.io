---
layout: post
share: true
title: "ActiveRecord::Relation new features in Rails 5"
modified: 2017-10-18T08:20:50-04:00
categories: blog
excerpt:
tags: []
image:
  feature:
date: 2017-10-18T08:20:50-04:00
---

#### ActiveRecord::Relation#or

After all this time, we finally have the #or method in ActiveRecord. We can call #or on a relation and pass another relation as its argument and it will generate an OR query. We can use it like this:

```ruby
class Issue < ApplicationRecord  
  scope :reported, -> { where(status: 'reported') }  
  scope :open,     -> { where(status: 'open') }
end
active_issues = Issue.reported.or(Issue.open)
```

#### ActiveRecord::Relation#in_batches

The new #in_batches method yields a relation, unlike #find_in_batches  which yields an array. We can use this method for things like this -

```ruby
Person.where('age >= 18').in_batches(of: 1000) do |people|  
  people.update_all(can_vote: true)
end
```
