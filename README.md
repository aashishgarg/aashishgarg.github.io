# So Simple Theme

Looking for a simple, responsive, theme for your Jekyll powered blog? Well look no further. Here be **So Simple Theme**, the followup to [**Minimal Mistakes**](http://mmistakes.github.io/minimal-mistakes/) -- by designer slash illustrator [Michael Rose](http://mademistakes.com).

## Notable features:

* Compatible with Jekyll 3 and GitHub Pages.
* Responsive templates. Looks good on mobile, tablet, and desktop devices.
* Gracefully degrading in older browsers. Compatible with Internet Explorer 9+ and all modern browsers.
* Minimal embellishments and subtle animations.
* Optional large feature images for posts and pages.
* [Custom 404 page](http://mmistakes.github.io/so-simple-theme/404.html) to get you started.
* Basic [search capabilities](https://github.com/mathaywarduk/jekyll-search)
* Support for Disqus Comments

![screenshot of So Simple Theme](http://mmistakes.github.io/so-simple-theme/images/so-simple-theme-preview.jpg)

See a [live version of So Simple](http://mmistakes.github.io/so-simple-theme/) hosted on GitHub.

---

## Getting Started

So Simple takes advantage of Sass and data files to make customizing easier and requires Jekyll 3.x.

To learn how to install and use this theme check out the [Setup Guide](http://mmistakes.github.io/so-simple-theme/theme-setup/) for more information.

## Useful Jekyll Commands

Below are some useful commands to help you work with this Jekyll project:

### Serve the Site Locally

```
bundle exec jekyll serve
```
Or, if you don't use Bundler:
```
jekyll serve
```
- Access your site at: http://localhost:4000

### Build the Site

```
bundle exec jekyll build
```
Or:
```
jekyll build
```

### Clean the Site

```
bundle exec jekyll clean
```
Or:
```
jekyll clean
```

### Serve Drafts and Future Posts

```
bundle exec jekyll serve --drafts --future
```

### Incremental Build (Faster)

```
bundle exec jekyll serve --incremental
```

### Use a Custom Configuration File

```
bundle exec jekyll serve --config _config.yml,_config_dev.yml
```

### Build for Production

```
JEKYLL_ENV=production bundle exec jekyll build
```

### Check for Site Problems

```
bundle exec jekyll doctor
```

### Install Dependencies

```
bundle install
```

---

## Docker Commands (Mac Silicon)

This project includes Docker support for consistent development environments on Mac Silicon (ARM64) machines.

### Start the Development Server

```bash
docker-compose up
```

### Start in Background

```bash
docker-compose up -d
```

### Stop the Server

```bash
docker-compose down
```

### Rebuild the Container

```bash
docker-compose build
```

### Build the Site for Production

```bash
docker-compose --profile build up jekyll-build
```

### Access the Site

Once running, access your site at: http://localhost:4000

### View Logs

```bash
docker-compose logs -f
```

### Run Commands Inside Container

```bash
docker-compose exec jekyll bundle _2.1.4_ exec jekyll build
```

### Alternative: Update Dependencies (Optional)

If you want to update to newer Ruby and gem versions, you can:

1. Update your Gemfile.lock locally:
```bash
bundle update
```

2. Then rebuild the Docker container:
```bash
docker-compose build --no-cache
```

---

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/mmistakes/so-simple-theme/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

---

## Recent Fixes and Improvements

This project has been updated with the following fixes and improvements:

### ✅ **Fixed Issues:**
- **Typo Correction**: Fixed filename `debuggibg-tools.md` → `debugging-tools.md`
- **Content Improvements**: Enhanced daily blog post with better structure and formatting
- **Configuration Updates**: 
  - Updated site description to reflect current experience
  - Enabled jekyll-feed plugin for RSS feeds
  - Improved homepage with better title and layout
- **Code Cleanup**: Removed TODO/FIXME comments from blog posts
- **Docker Support**: Added complete Docker setup for Mac Silicon machines
- **File Organization**: Added comprehensive .gitignore file

### 🚀 **New Features:**
- **Docker Development Environment**: Complete containerized setup for consistent development
- **Enhanced About Page**: Added Certifications and Recognitions section
- **Improved Homepage**: Better structure and navigation
- **Better Documentation**: Comprehensive README with all necessary commands

### 🔧 **Technical Improvements:**
- **Ruby Version Compatibility**: Fixed Docker setup for Ruby 2.7 compatibility
- **Bundler Version Management**: Proper bundler version handling in Docker
- **Build Optimization**: Added .dockerignore for faster builds
- **Development Workflow**: Streamlined commands for local and Docker development

---
