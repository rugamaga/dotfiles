#!/bin/bash

for item in $(brew list) ; do
  for use in $(brew uses --installed $item); do
    echo -n "$use "
  done
  echo -n "=> ${item} =>"
  for dep in $(brew deps --installed $item); do
    echo -n " $dep"
  done
  echo
done
