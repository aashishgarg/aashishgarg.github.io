---
layout: post
share: true
title: "Ruby code to bytecode"
modified: 2018-08-01T08:20:50-04:00
categories: ruby
excerpt:
tags: []
image:
  feature:
date: 2018-08-01T02:20:50-04:00
---

Our code's journey before actually getting executed to the machine level.

**Our Code -> Tokenize -> Parse -> Compile -> YARV instructions**

First, Ruby tokenizes your code, which means it reads the text characters in your code file and converts them into tokens, the words used in the Ruby language. Next, Ruby parses these tokens; that is, it groups the tokens into meaningful Ruby statements just as one might group words into sentences. Finally, Ruby compiles these statements into low-level instructions that it can execute later using a virtual machine.

Parser generators(Bison) take a series of grammar rules as input that describe the expected order and patterns in which the tokens 
will appear.
The grammar rule file for Bison and Yacc has a .y extension. In the Ruby source code, the grammar rule file is parse.y. The parse.y file defines the actual syntax and grammar that you have to use while writing your Ruby 
code; it’s really the heart and soul of Ruby and where the language itself is actually defined!

**Grammer or Rules(parse.y) -> Generate Parser(Bison) -> Parser code(parse.c**)

Starting with version 1.9, Ruby compiles your code before executing it.

YARV is a stack oriented virtual machine.
In addition to its own internal stack, YARV keeps track of your Ruby program’s call stack, recording which methods call 
which other methods, functions, blocks, lambdas, and so on. In fact, YARV is not just a stack machine—it’s a double-stack 
machine! It has to track the arguments and return values not only for its own internal instructions but also for your Ruby 
program.

**Ripper** is a Ruby script parser.
You can get information from the parser with event-based style. Information such as abstract syntax trees or simple lexical analysis of the Ruby program.

```ruby
require 'ripper'

Ripper.lex("puts 'hello india'")
Ripper.sexp("puts 'hello india'")
```
------------------------------------------------------------------------------------------------------------
**Acronyms** - 

**Compilation** is the process of translating the code of one programming language to another. Your programming language 
is easy for you to understand, while usually the target language is easy for the computer to understand.

For example, when you compile a C program, the compiler translates C code to machine language, a language your computer’s 
microprocessor hardware understands. When you compile a Java program, the compiler translates Java code to Java bytecode, 
a language the Java Virtual Machine understands. Ruby’s compiler is no different. It translates your Ruby code into another 
language that Ruby’s virtual machine understands.

**Bytecodes** are the series of low level instructions that the virtual machine understands.

**Identifiers** are words in your Ruby code that are not reserved words. Identifiers usually refer to variable, method, or class names.

**Reserved words** are keywords that carry significant meaning in Ruby because they provide the structure, or framework, of 
the language. They are called reserved words because you can’t use them as normal identifiers, although you can use them 
as method names, global variable names (such as $do ), or instance variable names (for example, @do or @@do ).

**AST** Abstract Syntax Tree



