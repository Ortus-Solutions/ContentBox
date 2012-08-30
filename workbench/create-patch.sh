#!/bin/sh
echo Creating ContentBox Release Updates Patch
SCRIPTDIR=`pwd`
# go back to root for diff of project
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
#git diff-tree -r --name-only --no-commit-id --diff-filter=ACMRT $1 $2 | xargs tar -rf $SCRIPTDIR/patches/$3/patch.tar
# create and zip up a patch release
git diff-tree -r --name-only --no-commit-id --diff-filter=ACMRT $1 $2 | zip $SCRIPTDIR/patches/$3/patch.zip -@
# create delete filelisting patch
git diff-tree -r --name-only --no-commit-id --diff-filter=D $1 $2 > $SCRIPTDIR/patches/$3/deletes.txt