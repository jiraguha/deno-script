#!/bin/bash
#======================
# Constants declaration
#======================

BUFIO_LIB="'https://deno.land/std@0.63.0/io/bufio.ts'"

#======================
# Functions declaration
#======================
readText(){
  # shellcheck disable=SC2028
  deno run --allow-read <(echo "
    const decoder = new TextDecoder('utf-8');
    const lines = Deno.args[0].split('\n');
    $1
  ") "$2"
}


readTextLine(){
  deno run --allow-read <(echo "
    import {readLines} from $BUFIO_LIB;
    const encoder =  new TextEncoder()
    const data = encoder.encode(Deno.args[0])
    const reader = new Deno.Buffer(data);
    for await (const line of readLines(reader)) {
      $1
    }
  ") "$2"
}

readFile(){
  # shellcheck disable=SC2028
  deno run --allow-read <(echo "
    const decoder = new TextDecoder('utf-8');
    const data = await Deno.readFile(Deno.args[0]);
    const lines = decoder.decode(data).split('\n');
    $1
  ") "$2"
}

readFileLine(){
  deno run --allow-read <(echo "
    import {readLines} from $BUFIO_LIB;
    const data = await Deno.readFile(Deno.args[0]);
    const reader = new Deno.Buffer(data);
    for await (const line of readLines(reader)) {
      $1
    }
  ") "$2"
}

#============================
# Main script
#============================

if [[ $1 =~ (--inline|-i) ]]; then
  deno run <(echo "$2") "${@:3}"
elif [[ $1 =~ (--pipe|-p) ]]; then
  while read arg; do
      deno run <(echo "$2") "$arg"
  done
elif [[ $1 =~ (--read-file-line) ]]; then
  readFileLine "$2" "$3"
elif [[ $1 =~ (--read-file) ]]; then
  readFile "$2" "$3"
elif [[ $1 =~ (--read-text-line) ]]; then
  readTextLine "$2" "$3"
elif [[ $1 =~ (--read-text) ]]; then
  readText "$2" "$3"
else
  # shellcheck disable=SC2068
  deno run $@
fi
