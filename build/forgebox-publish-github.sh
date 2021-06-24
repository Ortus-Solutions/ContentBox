#!/bin/bash
# Set to exit if any subcommand exists with a non 0 exit code
set -e
echo Publishing ContentBox Module - ${{ GITHUB_REF }};
cat ${{ GITHUB_WORKSPACE }}/build/build-contentbox/module/box.json;
cd ${{ GITHUB_WORKSPACE }}/build/build-contentbox/module && box forgebox publish;

echo Publishing ContentBox Site - ${{ GITHUB_REF }};
cat ${{ GITHUB_WORKSPACE }}/build/build-contentbox/site/box.json;
cd ${{ GITHUB_WORKSPACE }}/build/build-contentbox/site && box forgebox publish;

echo Publishing ContentBox Installer - ${{ GITHUB_REF }};
cat ${{ GITHUB_WORKSPACE }}/build/build-contentbox/installer/box.json;
cd ${{ GITHUB_WORKSPACE }}/build/build-contentbox/installer && box forgebox publish;

echo Publishing ContentBox Installer Module - ${{ GITHUB_REF }};
cat ${{ GITHUB_WORKSPACE }}/build/build-contentbox/installer-module/box.json;
cd ${{ GITHUB_WORKSPACE }}/build/build-contentbox/installer-module && box forgebox publish;