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
 
 # Run local script on remote host
 psql -U <username> -d <database> -h <host> -f <local_file>
 psql --username=<username> --dbname=<database> --host=<host> --file=<local_file>

# Backup database
pg_dump <database_name>

# Backup database, only data
pg_dump -a <database_name>
pg_dump --data-only <database_name>

# Backup database, only schema
pg_dump -s <database_name>
pg_dump --schema-only <database_name>

# Restore database data
pg_restore -d <database_name> -a <file_pathway>
pg_restore --dbname=<database_name> --data-only <file_pathway>

# restore database schema
pg_restore -d <database_name> -s <file_pathway>
pg_restore --dbname=<database_name> --schema-only <file_pathway>

# Export table into CSV file
\copy <table_name> TO '<file_path>' CSV

# Export table, only specific columns, to CSV file
\copy <table_name>(<column_1>,<column_1>,<column_1>) TO '<file_path>' CSV

# import CSV file into table
\copy <table_name> FROM '<file_path>' CSV

# import CSV file into table, only specific columns
\copy <table_name>(<column_1>,<column_1>,<column_1>) FROM '<file_path>' CSV

 
 SHOW ALL;  #-> Shows all lenvironment variables.
 
 \du
 => shows permissions of different users - 
 
 Role name  |                         Attributes                         | Member of 
------------+------------------------------------------------------------+-----------
 ashish     | Superuser, Create role, Create DB                          | {}
 ashishgarg | Cannot login                                               | {}
 postgres   | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
 root       | Superuser, Create role, Create DB                          | {}
 
```

###### Database commands

```bash
# lists all databases
\l

# Connect to a database
\c <database_name> 

# Show current database
SELECT current_database();

# Create database
CREATE DATABASE <database_name> WITH OWNER <username>;

# Delete database
DROP DATABASE IF EXISTS <database_name>;

# Rename database
ALTER DATABASE <old_name> RENAME TO <new_name>; 
```

###### User commands

```bash
# list all roles
SELECT rolname FROM pg_roles;

# Create user
CREATE USER <user_name> WITH PASSWORD '<password>';

# Drop database
DROP USER IF EXISTS <user_name>;

# Alter user password
ALTER ROLE <user_name> WITH PASSWORD '<password>';

```

###### Schema commands

```bash
# List all schemas
\dn 
SELECT schema_name FROM information_schema.schemata;
SELECT nspname FROM pg_catalog.pg_namespace;

# Create a schema
CREATE SCHEMA IF NOT EXISTS <schema_name>;

# Drop a schema
DROP SCHEMA IF EXISTS <schema_name> CASCADE;

```

###### Table commands

```bash
# List all tables in a database
\dt
SELECT table_schema,table_name FROM information_schema.tables ORDER BY table_schema,table_name;

# List tables globally
\dt *.*.
SELECT * FROM pg_catalog.pg_tables

\df <schema>  #=> lists all functions.

# List table schema
\d <table_name>
\d+ <table_name>

SELECT column_name, data_type, character_maximum_length
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = '<table_name>';

# Create table
CREATE TABLE <table_name>(
  <column_name> <column_type>,
  <column_name> <column_type>
);

# Create table, with an auto-incrementing primary key
CREATE TABLE <table_name> (
  <column_name> SERIAL PRIMARY KEY
);

# Delete table
DROP TABLE IF EXISTS <table_name> CASCADE;

```

