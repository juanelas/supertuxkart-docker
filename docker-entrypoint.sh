#!/bin/bash

args=()
while [ $# -gt 0 ]; do
  case "$1" in
    --login=*)
      login="${1#*=}"
      ;;
    --password=*)
      password="${1#*=}"
      ;;
    --init-user)
      ;;
    *)
      args+=("$1")
      ;;
  esac
  shift
done

[[ -n $login && -n $password ]] && /stk/bin/supertuxkart --init-user --login="$login" --password="$password"

[[ ${#args[@]} -gt 0 ]] && /stk/bin/supertuxkart $args
