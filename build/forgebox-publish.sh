#!/bin/bash
# Set to exit if any subcommand exists with a non 0 exit code
set -e
echo Publishing ContentBox Module - $BRANCH;
cat $WORKSPACE/build/build-contentbox/module/box.json;
cd $WORKSPACE/build/build-contentbox/module && box forgebox publish;

echo Publishing ContentBox Site - $BRANCH;
cat $WORKSPACE/build/build-contentbox/site/box.json;
cd $WORKSPACE/build/build-contentbox/site && box forgebox publish;

echo Publishing ContentBox Installer - $BRANCH;
cat $WORKSPACE/build/build-contentbox/installer/box.json;
cd $WORKSPACE/build/build-contentbox/installer && box forgebox publish;

echo Publishing ContentBox Installer Module - $BRANCH;
cat $WORKSPACE/build/build-contentbox/installer-module/box.json;
cd $WORKSPACE/build/build-contentbox/installer-module && box forgebox publish;