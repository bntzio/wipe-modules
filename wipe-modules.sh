#!/usr/bin/env bash

# variables
modules_removed=0
is_dir=0
is_number=0
run=0
initial_size=0
end_size=0

# usage info
usage() {
  cat <<EOF

  Usage: wipe-modules [options] [path] [days]

  Options:
    -d      Only show node_modules to be removed
    -l <#>  Specify a depth level

  Path:
    The full path of your code directory

  Days:
    The days you want to set to mark projects as inactive

  Example: wipe-modules ~/code 30

  That will remove the node_modules of your ~/code projects
  whose been inactive for 30 days or more.

  Keep in mind the order of the parameters you pass, first 
  goes the options (optional) and then the path and days (required)

EOF
exit 0
}

# getops parameters
while getopts dhl: flag; do
  case "$flag" in
    d) dry=1;;
    h) usage;;
    l) level=$OPTARG;;
    ?) usage;;
  esac
done

# shift parameters!
shift $((OPTIND - 1))

# positional parameters
code_dir=$1
last_modified=$2

# default depth level to 1 if not provided
if [ -z "$level" ]; then
  level=1
fi

# wipe node_modules
wipe() {
  dir="$1" # now dir is the 1st parameter ($1)
  dir="${dir%/}" # strip trailing slash
  dir="${dir##*/}" # strip path and leading slash
  if [[ "$dir" = .* ]]; then
    return
  fi
  cd "$dir" || exit
  if [ "$(find . -maxdepth "$level" -type d -name 'node_modules')" ]; then
    # if $dry exists then just print the name of the folder that
    # matches the search
    if [ -n "$dry" ]
    then
      # print the current directory name
      echo "$dir"
    else
      # wipe the node_modules folder!
      rm -rf node_modules
    fi

    # counter for modules to be removed
    modules_removed=$((modules_removed + 1))
  fi
  cd ..
}

# exit message
display_message() {
  if [ $modules_removed -gt 0 ]; then
    if [ -n "$dry" ]; then
      echo ""
      echo "$modules_removed node_modules were found!"
    else
      echo "$modules_removed node_modules successfully removed!"
      echo ""
      echo "Your initial directory size was $initial_size"
      echo "Now it is $end_size!"
    fi
  else
    echo "Our agent couldn't find any inactive projects."
  fi
}

# instructs agent gir to start ripping off those pesky node_modules
go_gir() {
  # move to code directory
  cd "$code_dir" || exit

  # grab the initial directory size
  initial_size=$(du -hs . | awk -F'\t' '{print $1;}')

  # if $dry is --dry (or -D) then show message
  if [ -n "$dry" ]; then
    echo " The node_modules in the following directories can be wiped out:"
    sleep 2
    echo ""
  fi

  # find $code_dir directories whose last modify time (mtime) is older than
  # $last_modified days, loop through each resulting dir and execute wipe function
  # then display message
  find . -maxdepth 1 -type d -mtime +"$last_modified" |
  {
    while read -r d; do
      wipe "$d"
    done

    # grab the new directory size!
    end_size=$(du -hs . | awk -F'\t' '{print $1;}')

    # show info
    display_message
  }
}

# check if $1 parameter is a valid directory
if [ -d "$code_dir" ]; then
  is_dir=1
fi

# check if $2 parameter is a valid number (regex)
last_modified=$(echo "$last_modified" | grep -E '^[0-9]+$')
if [ -n "$last_modified" ]; then
  is_number=1
fi

# if valid parameters are being passed then prepare for action
if [ $is_dir -eq 1 ] && [ $is_number -eq 1 ]; then
  run=1
fi

# if everything ok... press the green button!
if [ $run -eq 1 ]; then
  echo ""
  echo "Our agent is examining your files... Hold on a sec."
  sleep 2
  echo ""
  go_gir
  exit 0
else
  # something went wrong... abort the mission
  # if $is_dir is invalid, show error message and exit
  if [ $is_dir -eq 0 ]; then
    echo ""
    echo "Error: Invalid directory, please provide a valid one." >&2; exit 1
  fi
  # if $is_number is invalid, show error message and exit
  if [ $is_number -eq 0 ]; then
    echo ""
    echo "Error: Please provide a valid number." >&2; exit 1
  fi
fi
