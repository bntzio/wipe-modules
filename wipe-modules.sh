#!/usr/bin/env sh

# variables
code_dir=$1
last_modified=$2
modules_removed=0
is_dir=0
is_number=0
run=0

# instructs agent gir to start ripping off those pesky node_modules
go_gir() {
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
}

# check if $1 parameter is a valid directory
if [ -d "$code_dir" ]; then
  is_dir=1
fi

# check is $2 parameter is a valid number (regex)
regx='^[0-9]+$'
if [[ $last_modified =~ $regx ]]; then
  is_number=1
fi

# if valid parameters are being passed then prepare for action
if [ $is_dir -eq 1 -a $is_number -eq 1 ]; then
  run=1
fi

# if everything ok... press the green button!
if [ $run -eq 1 ]; then
  go_gir
  exit 0
else
  if [ $is_dir -eq 0 ]; then
    echo "Error: Invalid directory, please provide a valid one." >&2; exit 1
  fi
  if [ $is_number -eq 0 ]; then
    echo "Error: Please provide a valid number." >&2; exit 1
  fi
fi
