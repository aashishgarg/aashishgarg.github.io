---
layout: post
share: true
title: Jan 29, 2024
modified: 2024-01-29T22:17:25-04:00
excerpt: "Debugging dedicated day"
categories: daily_blog
image:
  feature: 
comments: true

---
# My Daily Hacks to Make Development Life Easier

In the world of software development, efficiency is key. As a developer, I'm constantly seeking ways to streamline my workflow and make my development life easier. Over time, I've developed several hacks and shortcuts that have become indispensable tools in my daily routine. Here's a glimpse into my arsenal of productivity-boosting tricks:

* Make terminal aliases for frequently used commands.

```bash
alias ws="cd /home/agarg/projects/project1"
alias wss="docker exec -it container-name bash"
alias rc="docker exec -it container-name bundle exec rails c"
```

* Make easy to use executable scripts to handle docker-compose commands to start different services.

```bash
#!/bin/bash

path="/home/projects/project1"
# Check if an argument is provided
if [ -z "$1" ]; then
    echo "Please provide an argument."
    exit 1
fi
# Start docker containers for sll-la
gnome-terminal --tab -- bash -c "cd '$path' && docker-compose -f docker-compose.dev.yml up $1"
```

* Echo Git branches of all my project repositories on terminal start.

```bash
```bash
#!/bin/bash

# Function to get branch name and status
get_branch_status() {
    local repo_path=$1
    local branch=$(git -C "$repo_path" rev-parse --abbrev-ref HEAD)
    local status=$([ -n "$(git -C "$repo_path" status --porcelain)" ] && echo "Local changes present" || echo "no local changes")
    printf "%-25s | %s\n" "$branch"  "$status"
}

# Define paths for each repository
SLL_LA_PATH=~/projects/sll-la/eportfolio
SLL_LA_INSIGHTS_PATH=~/projects/sll-la-insights
SLL_INFRA_PATH=~/projects/sll-infra
SLL_BASE_PATH=~/projects/sll-base

# Get branch names and status for each repository
SLL_LA=$(get_branch_status "$SLL_LA_PATH")
SLL_LA_INSIGHTS=$(get_branch_status "$SLL_LA_INSIGHTS_PATH")
SLL_INFRA=$(get_branch_status "$SLL_INFRA_PATH")
SLL_BASE=$(get_branch_status "$SLL_BASE_PATH")

# Print aligned output
echo "==================================================================="
echo "======= Git Branches =============================================="
echo "==================================================================="
printf "%-10s | %s\n" "SLL LA" "$SLL_LA"
printf "%-10s | %s\n" "INSIGHTS" "$SLL_LA_INSIGHTS"
printf "%-10s | %s\n" "SLL INFRA" "$SLL_INFRA"
printf "%-10s | %s\n" "SLL BASE" "$SLL_BASE"
```
