---
layout: post
share: true
title: "Multiline string in ruby"
modified: 2016-02-01T08:20:50-04:00
categories: blog
excerpt:
tags: []
image:
  feature:
date: 2016-02-01T08:20:50-04:00
---

(\) allows you to write single line string in mutiple lines in ruby code.

```ruby
puts 'ashish garg ashish garg ashish garg ashish garg ' \ 
        'new line'

  #=> 'ashish garg ashish garg ashish garg ashish garg new line'
```

(<<ASHISH) allows you to record and multi-line string.

```ruby
  a = <<ASHISH
  line1
  line2
  line3
  line4 
  ASHISH
  
  puts a    #=> "line1\nline2\nline3\nline4\n"
  
  b = p %{ 
  line1
  line2
  line3
  line4} 
  
  puts b    #=> "line1\nline2\nline3\nline4\n"
```
