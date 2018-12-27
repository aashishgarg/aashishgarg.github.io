---
layout: post
share: true
title: ":send method in ruby(Dynamic dispatch)"
modified: 2018-07-31T08:20:50-04:00
categories: ruby
excerpt:
tags: []
image:
  feature:
date: 2018-07-31T02:20:50-04:00
---
Dynamic dispatch in ruby allows us to send messages to an object.

```ruby
# object.public_send(message, *arguments)
1.public_send(:+, 2) # => 3
```

:send method even allows to invoke private methods.

```ruby
# object.send(message, *arguments)
1.send(:+, 2) # => 3
```

