#!/bin/sh
set -e

printf "\033[0;32mDeploying updates to GitHub...\033[0m\n"

git checkout master

# Build the project.
hugo

cd public

git add .

# Commit changes.
msg="rebuilding site $(date)"
if [ -n "$*" ]; then
	msg="$*"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master

git checkout main

cd ..