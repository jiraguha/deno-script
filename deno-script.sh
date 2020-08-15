#!/bin/bash

#======================
# Constants declaration
#======================

BUFIO_LIB="'https://deno.land/std@0.63.0/io/bufio.ts'"

#======================
# Arguments Handler
#======================

permissionPattern="^(--allow(-[a-z]+)+|-A)$"
optionPattern="^(--inline|-i|--pipe|-p|--read-file-line|--read-file|--read-text-line|--read-text)$"

handleArguments(){
  argCount=$#
  argArray=("$@")
  for (( j=0; j<argCount; j++ )); do
    if [[ ${argArray[j]} =~ $permissionPattern ]]; then
      # good for the deno installer
      permissionCatch="${permissionCatch:+$permissionCatch }${argArray[j]}"
    fi

    if [[ ${argArray[j]} =~ $optionPattern ]]; then
       optionDetected=1
    fi

    if [[ $optionDetected ]]; then
      tailedArg+=( "${argArray[j]}" )
    fi
  done
  tailedArgArray=( "${tailedArg[@]}" )
}

#======================
# Functionalities
#======================

readText(){
  deno run $permissionCatch <(echo "
    const decoder = new TextDecoder('utf-8');
    const lines = Deno.args[0].split('\n');
    $2
  ") "$3"
}


readTextLine(){
  deno run $permissionCatch <(echo "
    import {readLines} from $BUFIO_LIB;
    const encoder =  new TextEncoder()
    const data = encoder.encode(Deno.args[0])
    const reader = new Deno.Buffer(data);
    for await (const line of readLines(reader)) {
      $2
    }
  ") "$3"
}

readFile(){
  # shellcheck disable=SC2028
  deno run --allow-read $permissionCatch <(echo "
    const decoder = new TextDecoder('utf-8');
    const data = await Deno.readFile(Deno.args[0]);
    const lines = decoder.decode(data).split('\n');
    $2
  ") "$3"
}

readFileLine(){
  deno run --allow-read $permissionCatch <(echo "
    import {readLines} from $BUFIO_LIB;
    const data = await Deno.readFile(Deno.args[0]);
    const reader = new Deno.Buffer(data);
    for await (const line of readLines(reader)) {
      $2
    }
  ") "$3"
}

inline(){
  deno run --allow-read $permissionCatch <(echo "$2") "${@:3}"
}

#======================
# Options handler
#======================

handleOptions(){
  if [[ $1 =~ (--inline|-i) ]]; then
    inline "$@"
  elif [[ $1 =~ (--pipe|-p) ]]; then
    #fixme: use deno stdin
    while read arg; do
        deno run <(echo "$2") "$arg"
    done
  elif [[ $1 =~ --read-file-line ]]; then
    readFileLine "$@"
  elif [[ $1 =~ --read-file ]]; then
    readFile "$@"
  elif [[ $1 =~ --read-text-line ]]; then
    readTextLine "$@"
  elif [[ $1 =~ --read-text ]]; then
    readText "$@"
  fi
}

#============================
# Main script
#============================

handleArguments "$@"
if [[ $optionDetected ]]; then
  handleOptions "${tailedArgArray[@]}"
else
  deno run "$@"
fi
