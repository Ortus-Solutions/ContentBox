#!/bin/sh
echo Creating ContentBox Release Updates Patch

DIR=`pwd`
# go back to root for diff
cd ..
# check params
if [ -z "$1" ]
then
	echo "First commit ID is not defined"
	echo "Usage:$0 startCommitHash endCommitHash ContentBoxVersion"
	exit
fi
if [ -z "$2" ]
then
	echo "End commit ID is not defined"
	echo "Usage:$0 startCommitHash endCommitHash ContentBoxVersion"
	exit
fi
if [ -z "$3" ]
then
	echo "ContentBox Release Version is Needed"
	echo "Usage:$0 startCommitHash endCommitHash ContentBoxVersion"
	exit
fi

# create and tar up a release
#git diff-tree -r --name-only --no-commit-id --diff-filter=ACMRT $1 $2 | xargs tar -rf $DIR/contentbox_release_updates.tar
# create and zip up a patch release
git diff-tree -r --name-only --no-commit-id --diff-filter=ACMRT $1 $2 | zip $DIR/contentbox_$3_updates.zip -@
# create delete filelisting patch
git diff-tree -r --name-only --no-commit-id --diff-filter=D $1 $2 > $DIR/contentbox_$3_deletes.txt

