#!/bin/bash

function e {
  if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage: e [OPTION] [ENVIRONMENT]...
Handles multiple environment setups.

  -h, --help    Display this help and exit
  -l, --list    List available environments
  -d, --dump    Dump the current environment
  ENVIRONMENT   Load the specified environment

Check https://github.com/fabianopinto/e"
  elif [ "$1" = "-l" ] || [ "$1" = "--list" ]; then
    local old_pwd="$PWD"
    while [ "$PWD" != "/" ]; do
      if [ -d ".local" ]; then
        find .local -name "?*.env" -maxdepth 1 | sort | sed "s/^\.local\///; s/\.env$//"
      fi
      cd ..
    done
    cd "$old_pwd" || true
  elif [ "$1" = "-d" ] || [ "$1" = "--dump" ]; then
    for i in $__e; do
      if [[ "$i" =~ (PASSWORD|PASSWD|PWD) ]]; then
        echo "export $i='****'"
      else
        eval "echo \"export $i='\$$i'\""
      fi
    done
  else
    for i in $__e; do
      unset "$i"
    done
    __e=()
    local old_pwd="$PWD"
    while [ "$1" != "" ]; do
      while [ "$PWD" != "/" ]; do
        if [ -f ".local/$1.env" ]; then
          local perms=$(ls -l ".local/$1.env" | cut -c1-10)
          if [[ "$perms" =~ ^.r.x.-..-.$ ]]; then
            while IFS="" read -r line; do
              __e+=("$line")
            done < <(sed -E "s/^(export ([^=]+))?.*/\2/" ".local/$1.env")
            # shellcheck disable=SC1090
            source ".local/$1.env"
          else
            echo "Security risk ($perms): .local/$1.env" >&2
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
  fi
}
