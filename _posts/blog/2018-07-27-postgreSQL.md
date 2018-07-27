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
date: 2018-07-27T02:20:50-04:00
---

Postgres is an object-relational database management system. It was developed at **Berkeley Computer Science Department**, 
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

###### Connect with postgres

```bash
sudo su - postgres  # swich to the postgres user

psql  #enters into postgresql console

psql -U postgres -d my_db  # connects to [my_db] database

\q  OR \!  # Disconnects from postgresql console
```

###### change configuration of postgres

```bash
sudo nano $(locate -l 1 main/postgresql.conf)
sudo service postgresql restart
```

###### View logs

```bash
sudo tail -n 20 $(find /var/log/postgresql -name 'postgresql-*-main.log')
```

###### Informatory commands

```bash
SHOW SERVER_VERSION;
# => 
          server_version          
----------------------------------
 10.3 (Ubuntu 10.3-1.pgdg16.04+1)
 
 
 \conninfo
 # =>
 
 You are connected to database "postgres" as user "postgres" via socket in "/var/run/postgresql" at port "5432".
 
 SHOW ALL;  #-> Shows all lenvironment variables.
 SELECT rolname FROM pg_roles;  #=> lists all users
 SELECT current_user;  #=> Show current user
 
 \du
 => shows permissions of different users - 
 
 Role name  |                         Attributes                         | Member of 
------------+------------------------------------------------------------+-----------
 ashish     | Superuser, Create role, Create DB                          | {}
 ashishgarg | Cannot login                                               | {}
 postgres   | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
 root       | Superuser, Create role, Create DB                          | {}

 
```
