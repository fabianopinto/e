#!/bin/bash

function e {
  for i in $__e; do
    unset "$i"
  done
  __e=()
  local old_pwd=$PWD
  while [ "$1" != "" ]; do
    while [ "$PWD" != "/" ]; do
      if [ -f ".local/$1.env" ]; then
        if [[ "$(stat -c %A ".local/$1.env")" =~ ^.....-..-.$ ]]; then
          while IFS='' read -r line; do
            __e+=("$line")
          done < <(sed -E 's/^(export ([^=]+))?.*/\2/' ".local/$1.env")
          # shellcheck disable=SC1090
          source ".local/$1.env"
        else
          echo "Security risk ($(stat -c %A ".local/$1.env")): .local/$1.env" >&2
        fi
        break
      fi
      cd ..
      if [ "$PWD" = "/" ]; then
        echo "Environment not found: .local/$1.env" >&2
      fi
    done
    shift
    cd "$old_pwd" || true
  done
}
