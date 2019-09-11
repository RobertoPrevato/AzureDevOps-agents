#!/bin/bash
################################################################################
##  File:  preparemetadata.sh
##  Team:  CI-Platform
##  Desc:  This script adds a image title information to the metadata
##         document
################################################################################

source $HELPER_SCRIPTS/document.sh

AddTitle "Self-hosted Ubuntu 18.04 Image ($(lsb_release -ds))"
WriteItem "The following software is installed on machines in the Self-hosted Ubuntu 18.04 pool"
WriteItem "***"
