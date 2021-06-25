#!/bin/bash
# Set to exit if any subcommand exists with a non 0 exit code
set -e
echo Publishing ContentBox Module - $BRANCH;
cat build/build-contentbox/module/box.json;
cd build/build-contentbox/module && box forgebox publish && cd $WORKSPACE;

echo Publishing ContentBox Site - $BRANCH;
cat build/build-contentbox/site/box.json;
cd build/build-contentbox/site && box forgebox publish && cd $WORKSPACE;

echo Publishing ContentBox Installer - $BRANCH;
cat build/build-contentbox/installer/box.json;
cd build/build-contentbox/installer && box forgebox publish && cd $WORKSPACE;

echo Publishing ContentBox Installer Module - $BRANCH;
cat build/build-contentbox/installer-module/box.json;
cd build/build-contentbox/installer-module && box forgebox publish && cd $WORKSPACE;