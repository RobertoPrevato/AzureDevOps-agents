#!/bin/bash

print_info() {
  lightgreen='\e[92m'
  nocolor='\033[0m'
  echo -e "${lightgreen}[*] $1${nocolor}"
}

print_info "Making all bash scripts executable"

find . -type f -iname "*.sh" -exec chmod +x {} \;

print_info "Building base image"

cd ubuntu16.04-base

docker build -t devopsubuntu16.04:latest .

cd ..

print_info "Building Python image"

cd ubuntu16.04-python

docker build -t devopsubuntu16.04-python:latest .

cd ..

print_info "Building Docker inception image"

cd ubuntu16.04-docker

docker build -t devopsubuntu16.04-docker:latest .

cd ..

print_info "Building .NET Core image"

cd ubuntu16.04-dotnet

docker build -t devopsubuntu16.04-dotnet:latest

cd ..

print_info "Building Node.js image"

cd ubuntu16.04-nodejs

docker build -t devopsubuntu16.04-nodejs:latest

cd ..