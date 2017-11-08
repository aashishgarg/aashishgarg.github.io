---
layout: post
share: true
title: "Hash Keys(symbol vs string) in Ruby"
modified: 2017-10-23T08:20:50-04:00
categories: blog
excerpt:
tags: []
image:
  feature:
date: 2017-10-23T08:20:50-04:00
---

**Problem** - While using a normal hash in ruby, value for symbol type of key in the hash cannot be retrieved with equivalent string.

*Example*

```
developer = {name: 'ashish', company: 'Headerlabs'}
developer[:name] => 'ashish'
developer['name'] => nil
```

**Solution** - The Hash class in the Ruby's core retrieves values by doing a standard == comparison on the keys.
For retrieving values interchangeably, ruby provides HashWithInDifferentAccess  which treat the symbol keys and string keys equally.

```
developer = HashWithInDifferentAccess.new
developer[:name] = 'ashish'
developer['name']    =>  'ashish'
```
