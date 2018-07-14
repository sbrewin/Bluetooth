#!/bin/bash

# Docs by jazzy
# https://github.com/realm/jazzy
# ------------------------------

git submodule update --remote

# Jazzy
cd Bluetooth
cp .jazzy.yaml ../
cp README.md ../
cp -rf Assets ../
cd ../
jazzy --source-directory Bluetooth
rm -rf docs/docsets
