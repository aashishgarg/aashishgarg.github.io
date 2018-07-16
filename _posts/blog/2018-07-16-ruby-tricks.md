---
layout: post
share: true
title: "New methods introduced in ruby 2.5"
modified: 2018-07-16T08:20:50-04:00
categories: blog
excerpt:
tags: []
image:
  feature:
date: 2017-12-16T08:20:50-04:00
---

#### Ruby 2.5
Released on 25 Dec 2017. A lot of improvements were introduced in this release. 
New methods were part of this improvements.

* Arry#prepend

```ruby
array = [1, 2]
array.prepend(3, 4)
array #=> [3, 4, 1, 2]
```
* Array#append

```ruby
array = [1, 2]
array.append(3, 4)
array #=> [1, 2, 3, 4]
```

* Hash#transform_keys/transform_keys!

```ruby
hash = {a: 1, b: 2}
hash.transform_keys(&:to_s) => {'a' => 1, 'b' => 2}
hash.transform_keys!(&:to_s)
{'a' => 1, 'b' => 2}
```

* String#delete_prefix/delete_suffix

```ruby
'invisible'.delete_prefix('in') #=> "visible"
'pink'.delete_prefix('in') #=> "pink"
 
'worked'.delete_suffix('ed') #=> "work"
'medical'.delete_suffix('ed') #=> "medical"
```

* rescue/else/ensure are allowed inside do/end blocks without begin/end

```ruby
[1].each do |n|
  n / 0
rescue
  # rescue
else
  # else
ensure
  # ensure
end
```

* Dir.children - It provides the result with ['.', '..']

```ruby
Dir.children('./test/dir_a')
#=> ['code_a.rb', 'text_a.txt']
```

* Dir.each_child returns not an array but an Enumerator object

```ruby
Dir.each_child('./test/dir_a')
#=> #<Enumerator: Dir:each_child(\"./test/dir_a\")>"
 
Dir.each_child('./test/dir_a').to_a
#=> ['code_a.rb', 'text_a.txt']
```

Thanks for reading!!!
