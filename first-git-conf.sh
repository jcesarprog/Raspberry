#!/bin/bash
git config --global user.name "Julio Teixeira"
git config --global user.email "jcesarprog@gmail.com"
git config --global core.editor vim
echo "Listing git configurations"
git config --list --show-origin