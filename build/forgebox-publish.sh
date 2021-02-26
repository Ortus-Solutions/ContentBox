#!/bin/bash
# Set to exit if any subcommand exists with a non 0 exit code
set -e
# Only do non-pull requests
if [ "${TRAVIS_PULL_REQUEST}" = "false" ]; then
	# Only publish on the first engine, not every engine
	if [ "${ENGINE}" = "lucee@5" ]; then
		echo Publishing ContentBox Module - $TRAVIS_BRANCH;
		cat $TRAVIS_BUILD_DIR/build/build-contentbox/module/box.json;
		cd $TRAVIS_BUILD_DIR/build/build-contentbox/module && box forgebox publish && cd $TRAVIS_BUILD_DIR;

		echo Publishing ContentBox Site - $TRAVIS_BRANCH;
		cat $TRAVIS_BUILD_DIR/build/build-contentbox/site/box.json;
		cd $TRAVIS_BUILD_DIR/build/build-contentbox/site && box forgebox publish && cd $TRAVIS_BUILD_DIR;

		echo Publishing ContentBox Installer - $TRAVIS_BRANCH;
		cat $TRAVIS_BUILD_DIR/build/build-contentbox/installer/box.json;
		cd $TRAVIS_BUILD_DIR/build/build-contentbox/installer && box forgebox publish && cd $TRAVIS_BUILD_DIR;

		echo Publishing ContentBox Installer Module - $TRAVIS_BRANCH;
		cat $TRAVIS_BUILD_DIR/build/build-contentbox/installer-module/box.json;
		cd $TRAVIS_BUILD_DIR/build/build-contentbox/installer-module && box forgebox publish && cd $TRAVIS_BUILD_DIR;
	fi
fi