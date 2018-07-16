---
layout: post
share: true
title: "ROR tricks"
modified: 2018-07-16T08:20:50-04:00
categories: blog
excerpt:
tags: []
image:
  feature:
date: 2018-07-16T08:20:50-04:00
---

#### Few tricks
Some of the ruby syntax that I was not using in my regular life.

* Hash[...]

```ruby
Hash[1,2,3,4,5,6]
#=> {1=>2, 3=>4, 5=>6}
```
* Double star(**)

```ruby
def new_method(a, *b, **c)
  return a, b, c
end
```
a is a regular parameter. *b will take all the parameters passed after the first one and put them in an array. **c will take any parameter given in the format key: value at the end of the method call.

```ruby
new_method(1)
#=> [1, [], {}]

new_method(1, 2, 3)
#=> [1, [2, 3]]

new_method(1, 2, 3, a: 4, b: 5)
#=> [1, [2, 3], {a: 4, b: 5}]
```

* Mandatory hash parameters

```ruby
def new_method(a:, b:, c: 'hello')
  return a, b, c
end

new_method(a: 1, b: 2)
#=> [1, 2, 'hello']

new_method(a: 1, b: 2, c: 3)
#=> [1, 2, 3]
```

This was introduced in Ruby 2.0. We can define the keys in the parameters.

* Default value for hash

```ruby
a = Hash.new(0)
a[:a]
# => 0

a = Hash.new({})
a[:a]
# => {}

a = Hash.new('hello')
a[:a]
# => "hello"
```
By default, when trying to access a value not defined in a hash, we will receive nil. We can actually change this at initialization.


* The ‘presence’ method: [@object.presence]

```ruby
hash = {a: 1, b: 2}

hash[a].present?
#=> true

hash[a].presence
#=> 1

hash[c].present?
#=> nil

hash[c].presence
#=> nil

```
The presence method goes one step further than **@object.present?** by returning the attribute or value being checked for rather than just true.

* Helper methods

```ruby
helper.display_name('first name', 'last name')
```
Rails view helpers can be accessed in the rails console.

* Sanbox mode

```ruby
rails c --sandbox
```
When rails console is under the sandbox option, all the database operations are rolled back in the end when the console is closed.
All the queries run under a transaction which is rolled back in the end.
Hence there is no chance of changing the actual data by mistake while accessing the databases through the rails console.

* Access last evaluated result

```ruby
User.last
a = _.id
#=> 14
```
Last evaluated expression in the console can be accessed through the (_). 

* Query by range

```ruby
User.where(created_at: 10.days.ago..Time.now).to_sql
```
It applies the "BETWEEN" in the sql query prepared by the active record.

* Pretend generate
```ruby
rails g model comment body:text post_id:integer -p
invoke  active_record
create    db/migrate/20141002023923_create_comments.rb
create    app/models/comment.rb
invoke    test_unit
create      test/models/comment_test.rb
create      test/fixtures/comments.yml
```
If you need to find out what files will be created/modified, you can run a pretend migration.

* rake notes

```ruby
# TODO
# FIXME
# OPTIMIZE
```

We can do a search for the string within your project to see all these comments. Alternatively, Rails provide **rake notes**, which will show the list of the comments that begins with these strings:
s
```ruby
$  rake notes
app/controllers/application_controller.rb:
  * [6] [FIXME] Title is not dynamic for each page

app/controllers/posts_controller.rb:
  * [7] [TODO] It is better if we can avoid these unecessary joins.

app/models/post.rb:
  * [3] [OPTIMIZE] This is too slow. Better to use pluck
```



