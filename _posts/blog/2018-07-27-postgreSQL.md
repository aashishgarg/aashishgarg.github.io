---
layout: post
share: true
title: "PostgreSQL"
modified: 2018-07-27T08:20:50-04:00
categories: blog
excerpt:
tags: []
image:
  feature:
date: 2018-07-27T01:20:50-04:00
---

Postgres is a object-relational database management system. It was developed at **Berkeley Computer Science Department**, 
university of california.

###### Installation in Ubuntu

```bash
sudo sh -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main' > /etc/apt/sources.list.d/pgdg.list"
wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install postgresql-common
sudo apt-get install postgresql-9.5 libpq-dev
```
The PostgreSQL does not setup a user, so we need to create a user with permission to 
create database.

```bash
 sudo -u postgres createuser new_user -s
 
 # If you would like to set a password for the user, you can do the following
 sudo -u postgres psql
 postgres=# \password new_user
```

