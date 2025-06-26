---
layout: post
share: true
title: "Rails Skeleton App with Docker: A Clean Setup for Beginners (No Local Install Needed)"
modified: 2025-06-23T23:00:00-04:00
categories: rails
excerpt: "Learn how to create a Rails 8 project with PostgreSQL using Docker - no local Ruby, Rails, or database installation required. Perfect for beginners and teams."
tags: [rails, docker, postgresql, beginners, development-environment, containerization]
image:
  feature: 
comments: true
date: 2025-06-23T23:00:00-04:00
---

As someone who has led multiple Rails projects and worked with diverse teams, one challenge I often see new developers face is setting up their development environment correctly. Different OS versions, Ruby versions, Postgres configurations — all of this can become overwhelming quickly.

That's where Docker comes in. It simplifies development by giving you a consistent, containerized environment that mirrors production — without cluttering your system with dependencies.

## Why I Wrote This

This post is for freshers, interns, or anyone new to Docker or Rails. If you've ever thought:

- "I don't want to install Ruby/Rails/PostgreSQL just to try it out."
- "I want a clean and consistent dev setup."
- "I've heard about Docker but never used it in practice."

This approach is for you.

## What You'll Achieve

By following the process I outline here, you'll:

- Create a fresh Rails 8 project
- Set up a PostgreSQL database
- Run your Rails server — all inside Docker containers
- Avoid installing Ruby, Node, or Postgres on your machine

In short: everything runs in Docker. Your host machine stays clean.

## Prerequisites

The only thing you need installed locally is **Docker**. That's it!

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) for Mac/Windows
- [Docker Engine](https://docs.docker.com/engine/install/) for Linux

## High-Level Steps

Here's a quick overview of what we do:

1. Create a project folder to hold your app
2. Write a Dockerfile to define your Rails container
3. Add a Gemfile with your Rails version
4. Create a docker-compose file to run both the app and a PostgreSQL service
5. Build your Docker image and generate a new Rails project inside the container
6. Adjust database settings to connect to the Dockerized Postgres
7. Start your app and create the database inside the running container

## Step-by-Step Implementation

### 1. Create Project Structure

```bash
mkdir rails-docker-app
cd rails-docker-app
```

### 2. Create Dockerfile

```dockerfile
# Use Ruby 3.2 slim image
FROM ruby:3.2-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    npm \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Install bundler
RUN gem install bundler

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy the rest of the application
COPY . .

# Add a script to be executed every time the container starts
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]
```

### 3. Create Gemfile

```ruby
source "https://rubygems.org"

ruby "3.2.2"

# Rails framework
gem "rails", "~> 7.1.0"

# Database
gem "pg", "~> 1.1"

# Asset pipeline
gem "sprockets-rails"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  gem "web-console"
end
```

### 4. Create docker-compose.yml

```yaml
version: '3.8'

services:
  db:
    image: postgres:15
    volumes:
      - postgres_data:/var/lib/postgresql/data
    environment:
      POSTGRES_PASSWORD: password
      POSTGRES_USER: postgres
      POSTGRES_DB: rails_app_development
    ports:
      - "5432:5432"

  web:
    build: .
    command: bash -c "rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'"
    volumes:
      - .:/app
      - bundle_cache:/usr/local/bundle
    ports:
      - "3000:3000"
    depends_on:
      - db
    environment:
      DATABASE_URL: postgres://postgres:password@db:5432/rails_app_development
      RAILS_ENV: development

volumes:
  postgres_data:
  bundle_cache:
```

### 5. Create Entrypoint Script

```bash
#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails
rm -f /app/tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile)
exec "$@"
```

### 6. Create Rails Application

```bash
# Build the Docker image
docker-compose build

# Generate a new Rails application inside the container
docker-compose run --rm web rails new . --force --database=postgresql --skip-git

# Set proper permissions
sudo chown -R $USER:$USER .
```

### 7. Configure Database

Update `config/database.yml`:

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  url: <%= ENV['DATABASE_URL'] %>

development:
  <<: *default
  database: rails_app_development

test:
  <<: *default
  database: rails_app_test

production:
  <<: *default
  database: rails_app_production
  username: rails_app
  password: <%= ENV["RAILS_APP_DATABASE_PASSWORD"] %>
```

### 8. Start the Application

```bash
# Create and migrate the database
docker-compose run --rm web rails db:create db:migrate

# Start the application
docker-compose up
```

Your Rails application will now be running at `http://localhost:3000`!

## Real-World Benefits

### Consistency
Every developer on your team gets the same environment, regardless of OS. No more "it works on my machine" issues.

### Simplicity
No more manual installs, version conflicts, or messing with local databases. Everything is isolated and reproducible.

### Portability
Move your project from dev to staging or prod with ease. The same containers can run anywhere Docker is available.

### Onboarding
New team members can start contributing in minutes, not days. Just clone the repo and run `docker-compose up`.

## Common Commands

```bash
# Start the application
docker-compose up

# Start in background
docker-compose up -d

# Stop the application
docker-compose down

# Run Rails console
docker-compose run --rm web rails console

# Run database migrations
docker-compose run --rm web rails db:migrate

# Run tests
docker-compose run --rm web rails test

# Install new gems
docker-compose run --rm web bundle install
```

## Troubleshooting

### Permission Issues
If you encounter permission issues on Linux/Mac:

```bash
sudo chown -R $USER:$USER .
```

### Database Connection Issues
Ensure the database service is running:

```bash
docker-compose ps
```

### Port Conflicts
If port 3000 is already in use, change it in `docker-compose.yml`:

```yaml
ports:
  - "3001:3000"  # Use port 3001 on host
```

## Advice for Beginners

If you're just starting out:

1. **Don't be intimidated by Docker**. It's just a tool to isolate and manage environments.
2. **Focus on understanding** what each component (Dockerfile, Compose, volumes, etc.) does.
3. **Experiment!** Break things and rebuild — that's how real learning happens.
4. **Start small** and gradually add complexity as you become comfortable.

## Next Steps

Once you're comfortable with this setup, you can:

- Add Redis for caching
- Set up background job processing with Sidekiq
- Configure Nginx as a reverse proxy
- Add monitoring and logging
- Set up CI/CD pipelines

## Resources

- [Docker Documentation](https://docs.docker.com/)
- [Rails Documentation](https://guides.rubyonrails.org/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

## Conclusion

This Docker-based Rails setup provides a clean, consistent, and portable development environment. It eliminates the complexity of managing multiple Ruby versions, database configurations, and system dependencies locally.

For beginners, this approach removes barriers to entry and allows you to focus on learning Rails rather than fighting with environment setup. For teams, it ensures everyone works with the same configuration and reduces onboarding time.

Remember: the goal is to make development easier, not harder. Docker is a tool that should simplify your workflow, not complicate it.

Happy coding! 🚀

---

*This article is based on my experience leading Rails projects and helping teams adopt Docker for development. For a detailed PDF guide with full steps, check out the [complete setup guide](https://drive.google.com/file/d/1ixoSn8dXDpwGuOFF73OsiNK1mGmzd1YN/view?usp=sharing).* 