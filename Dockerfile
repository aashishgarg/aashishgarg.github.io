# Use Ruby 2.7 slim image optimized for ARM64 (Mac Silicon) - compatible with existing Gemfile.lock
FROM --platform=linux/arm64 ruby:2.7-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Install the specific bundler version that matches Gemfile.lock
RUN gem install bundler -v 2.1.4

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install Ruby gems with the correct bundler version
RUN bundle _2.1.4_ install

# Copy the rest of the application
COPY . .

# Expose port 4000
EXPOSE 4000

# Set environment variables
ENV JEKYLL_ENV=development
ENV LANG=C.UTF-8

# Default command to serve Jekyll
CMD ["bundle", "_2.1.4_", "exec", "jekyll", "serve", "--host", "0.0.0.0", "--port", "4000", "--livereload"] 