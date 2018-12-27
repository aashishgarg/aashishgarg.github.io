---
layout: post
share: true
title: "Difference between += and concat"
modified: 2016-01-23T08:20:50-04:00
categories: blog
excerpt:
tags: []
image:
  feature:
date: 2016-01-23T08:20:50-04:00
---

Learning ruby is really fun and one should enjoy learning ruby language.

In ruby there are many situations where one feel that there two operators which can be used replace ably without giving 
own-self a try to know the actual difference between them. 

One of them is += and concat.

(All the gotcha lies in object_id concept) 

Here its actually creates a new object and points the old variable to that new object. 

```ruby
  a = 'ashish'
  a.object_id    #=> 21005340
  
  b = a
  b.object_id    #=>21005340
  
  a.concat(' garg') 
  a.object_id    #=>21005340
  b.object_id    #=>21005340
  puts a         #=>'ashish garg'
  puts b         #=>'ashish garg' 
  
  a += ' hello'
  a.object_id    #=>19987654 (Here new object created and pointed to that variable.)
  b.object_id    #=>21005340
  puts a         #=>'ashish garg hello'
  puts b         #=>'ashish garg' 
```
