#!/bin/bash
set -e

echo -e "\033[0;31mDEPRECATED: Manual deployment is no longer required.\033[0m"
echo -e "\033[0;32mSimply push your changes to the master branch, and GitHub Actions will handle the deployment.\033[0m"
echo ""
echo "Pushing to master..."

git push origin master
