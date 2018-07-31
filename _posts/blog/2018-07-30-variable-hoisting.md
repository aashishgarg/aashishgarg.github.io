---
layout: post
share: true
title: "Variable hoisting"
modified: 2018-07-30T08:20:50-04:00
categories: blog
excerpt:
tags: []
image:
  feature:
date: 2018-07-30T05:20:50-04:00
---

**Variable Hoisting** is a mechanism by which the Ruby declares and defines variables.

We can understand with the help of simple examples - 

```ruby
# run the code below in console
puts a

# we get the following error because a is not defined.
#-> NameError: undefined local variable or method `x' for main:Object.
```

Now try the next code - 

```ruby
a = 1 if true
puts a
# => 1

#-> This output is also very obvious.
```

But what happens when we run following code - 

```ruby
a = 1 if false
puts a
# => nil

#-> Here we do not get any error.
```

When we try to call an undefined variable we will get a NameError. But if we define the variable in a part of the code that will not be run at all, we get a nil.

This happens due to the ruby parser. Basically when parser runs over the if-clause, it first declares the variables, regardless of whether it will actually be executed.
Don't confuse parser with interpreter. The parser does not care whether (a) ever gets a value. The job of the parser is just to go over the code, find any local variables and allocate space for those variables with nil as value.

Its the interpreter's job to follow the logical path of the program and see if (a) will get a value.

Variable hoisting in Ruby is much different than the JavaScript.

