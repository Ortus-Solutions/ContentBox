#!/bin/sh

# check start commit id
if [ -z "$1" ]
then
	echo "First commit ID is not defined"
	echo "Usage:$0 startCommitHash endCommitHash ContentBoxVersion"
	exit
fi

# check end commit id
if [ -z "$2" ]
then
	echo "End commit ID is not defined"
	echo "Usage:$0 startCommitHash endCommitHash ContentBoxVersion repoRoot"
	exit
fi

# check version
if [ -z "$3" ]
then
	echo "ContentBox Release Version is Needed"
	echo "Usage:$0 startCommitHash endCommitHash ContentBoxVersion repoRoot"
	exit
fi

# check repository root
if [ -z "$4" ]
then
	echo "ContentBox Repsoitory Root is Needed"
	echo "Usage:$0 startCommitHash endCommitHash ContentBoxVersion repoRoot"
	exit
else
	REPO_ROOT=$4
fi

echo ****************************************************************************
echo Start Commit: $1
echo End Commit: $2
echo Version: $3
echo Repo Root: $4
echo ****************************************************************************
echo 

# switch to repo root
cd $REPO_ROOT

# create and zip up a patch release
git diff-tree -r --name-only --no-commit-id --diff-filter=ACMRT $1 $2 | zip $REPO_ROOT/workbench/patches/$3/patch.zip -@

# create delete filelisting patch, exclude external stuff
git diff-tree -r --name-only --no-commit-id --diff-filter=D $1 $2 | grep -E -v '^(includes|config|tests?|views|model|layouts|handlers|workbench)' > $REPO_ROOT/workbench/patches/$3/deletes.txt
