#!/usr/bin/env sh

# variables
code_dir=$1
last_modified=$2
modules_removed=0

# move to code directory
cd $code_dir

# loop through code directory folders
for d in */ ; do
  # move to code dir subdirectory
  cd $d
  # search for node_modules folder whose last modified date is >= than $last_modified days
  if [ `find . -maxdepth 1 -type d -mtime -$last_modified -name 'node_modules'` ]
  then
    # wipe the node_modules folder!
    rm -rf node_modules
    modules_removed=`expr $modules_removed + 1`
  fi
  # go one directory up to continue iterating
  cd ..
done

# display nice little information message
echo "$modules_removed node_modules successfully removed!"
