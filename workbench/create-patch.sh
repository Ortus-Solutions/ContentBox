#!/bin/sh
echo Creating ContentBox Release Updates Patch

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
if [ -z "$4" ]
then
	# default to script dir
	SCRIPTDIR=`pwd`
	# go back to root for diff of project
	cd ..
else
	cd $4
fi

echo "Running commands from: " `pwd`
echo "Start Commit: $1"
echo "End Commit: $2"

# create and tar up a release
#git diff-tree -r --name-only --no-commit-id --diff-filter=ACMRT $1 $2 | xargs tar -rf $4/workbench/patches/$3/patch.tar

# create and zip up a patch release
git diff-tree -r --name-only --no-commit-id --diff-filter=ACMRT $1 $2 | zip $4/workbench/patches/$3/patch.zip -@

# create delete filelisting patch, exclude external stuff
git diff-tree -r --name-only --no-commit-id --diff-filter=D $1 $2 | grep -E -v '^(includes|config|tests?|views|model|layouts|handlers|workbench)' > $4/workbench/patches/$3/deletes.txt
