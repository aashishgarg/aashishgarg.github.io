---
layout: post
share: true
title: "Different ruby interpreters"
modified: 2018-07-3T08:20:50-04:00
categories: blog
excerpt:
tags: []
image:
  feature:
date: 2018-07-3T02:20:50-04:00
---

**Interpreter** is a program that reads your source code, converts it into a series of executable instructions and then run them.
Its like a compiler but it runs our code directly without producing an output file.

Different production-ready Ruby interpreters - 

* MRI (The original implementation & what most people use)
* Rubinius
* JRuby

**MRI** stands for **Matz’s Ruby Interpreter**, but some of the core developers prefer to call it **CRuby**. It was created (and is still maintained by) Yukihiro Matsumoto (Matz) in 1995 & it’s written entirely in C.

Then we have **JRuby**, which is written in Java & runs on the JVM (Java Virtual Machine). One thing you can do, that isn’t possible in any other Ruby interpreter, is to use Java libraries in your code.

The main goal of **Rubinius** is to have a Ruby interpreter written in Ruby itself (but there are still some parts written in C++).

Another important difference between MRI & other interpreters is that MRI has **GIL** (Global Interpreter Lock). A goal for **Ruby 3.0** is to remove the GIL.
