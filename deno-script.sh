#!/bin/bash
BUFIO_LIB="'https://deno.land/std@0.63.0/io/bufio.ts'"
if [[ $1 =~ (--inline|-i) ]]; then
    deno run <(echo $2) "${@:3}"
elif [[ $1 =~ (--pipe|-p) ]]; then
    while read arg; do
        deno run <(echo $2) "$arg"
    done
elif [[ $1 =~ (--read-file-line) ]]; then
    deno run --allow-read <(echo "
import {readLines} from $BUFIO_LIB;
const data = await Deno.readFile(Deno.args[0]);
const reader = new Deno.Buffer(data);
for await (const line of readLines(reader)) {
    $2
}") "$3"
elif [[ $1 =~ (--read-file) ]]; then
    deno run --allow-read <(echo "
const decoder = new TextDecoder('utf-8');
const data = await Deno.readFile(Deno.args[0]);
const lines = decoder.decode(data).split('\n');
$2
") "$3"
elif [[ $1 =~ (--read-text-line) ]]; then
    deno run --allow-read <(echo "
import {readLines} from $BUFIO_LIB;
const encoder =  new TextEncoder()
const data = encoder.encode(Deno.args[0])
const reader = new Deno.Buffer(data);
for await (const line of readLines(reader)) {
    $2
}") "$3"
elif [[ $1 =~ (--read-text) ]]; then
  deno run --allow-read <(echo "
const decoder = new TextDecoder('utf-8');
const lines = Deno.args[0].split('\n');
$2
") "$3"
else
    deno run $@
fi
