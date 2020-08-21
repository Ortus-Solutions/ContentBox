#!/bin/bash
# Set to exit if any subcommand exists with a non 0 exit code
set -e
# Only do non-pull requests
if [ "${TRAVIS_PULL_REQUEST}" = "false" ]; then
	# Only publish on the first engine, not every engine
	if [ "${ENGINE}" = "lucee@5" ]; then
		echo Publishing Module - $TRAVIS_BRANCH;
		cat $TRAVIS_BUILD_DIR/build/build-contentbox/module/box.json;
		cd $TRAVIS_BUILD_DIR/build/build-contentbox/module && box forgebox publish && cd $TRAVIS_BUILD_DIR;

		echo Publishing Site - $TRAVIS_BRANCH;
		cat $TRAVIS_BUILD_DIR/build/build-contentbox/site/box.json;
		cd $TRAVIS_BUILD_DIR/build/build-contentbox/site && box forgebox publish && cd $TRAVIS_BUILD_DIR;

		echo Publishing Installer - $TRAVIS_BRANCH;
		cat $TRAVIS_BUILD_DIR/build/build-contentbox/installer/box.json;
		cd $TRAVIS_BUILD_DIR/build/build-contentbox/installer && box forgebox publish && cd $TRAVIS_BUILD_DIR;

		echo Publishing Installer Module - $TRAVIS_BRANCH;
		cat $TRAVIS_BUILD_DIR/build/build-contentbox/installer-module/box.json;
		cd $TRAVIS_BUILD_DIR/build/build-contentbox/installer-module && box forgebox publish && cd $TRAVIS_BUILD_DIR;

		if [ $TRAVIS_BRANCH == 'development' ]; then
			echo Publishing Beta Updates Channel;
			cd $TRAVIS_BUILD_DIR/build/build-contentbox/forgebox/beta-updates && box forgebox publish && cd $TRAVIS_BUILD_DIR;
		fi

		if [ $TRAVIS_BRANCH == 'master' ]; then
			echo Publishing Stable Updates Channel;
			cd $TRAVIS_BUILD_DIR/build/build-contentbox/forgebox/stable-updates && box forgebox publish && cd $TRAVIS_BUILD_DIR;
		fi
	fi
fi