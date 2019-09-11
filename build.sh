#!/bin/bash

print_info() {
  lightgreen='\e[92m'
  nocolor='\033[0m'
  echo -e "${lightgreen}[*] $1${nocolor}"
}

print_info "Making all bash scripts executable"

find . -type f -iname "*.sh" -exec chmod +x {} \;

# Select the version you prefer, or both (16.04 18.04)
for VERSION in 18.04
do

  print_info "Building base image"

  cd ubuntu$VERSION-base

  docker build -t devopsubuntu$VERSION:latest .

  cd ..

  print_info "Building Python image"

  cd ubuntu$VERSION-python

  docker build -t devopsubuntu$VERSION-python:latest .

  cd ..

  print_info "Building Docker inception image"

  cd ubuntu$VERSION-docker

  docker build -t devopsubuntu$VERSION-docker:latest .

  cd ..

  print_info "Building .NET Core image"

  cd ubuntu$VERSION-dotnet

  docker build -t devopsubuntu$VERSION-dotnet:latest .

  cd ..

  print_info "Building Node.js image"

  cd ubuntu$VERSION-nodejs

  docker build -t devopsubuntu$VERSION-nodejs:latest .

  cd ..
done
