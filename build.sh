#!/bin/bash

set -euxo pipefail

while getopts ":b:p:" opt; do
  case ${opt} in
    b )
      BOARD=$OPTARG
      ;;
    p )
      PROJECT_NAME=$OPTARG
      ;;
    : )
      echo "$OPTARG requires an argument" 1>&2
      exit 1
      ;;
  esac
done

if [ -z "$BOARD" ]; then
  echo "No board specified, use \$BOARD or -b"
  exit 1
fi

if [ -z "$PROJECT_NAME" ]; then
  echo "No project name specified, use \$PROJECT_NAME or -p"
  exit 1
fi

# We're expecting to be started with our current working directory pointing into the source repo.
# Replace the prefetched mirror with our own project.
rm -rf /zephyr/.west
cp -rf "`pwd`" "/zephyr/$PROJECT_NAME"
cd "/zephyr/$PROJECT_NAME"
west init -l
west update
west build -b $BOARD
