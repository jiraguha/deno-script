#!/bin/bash
shopt -s expand_aliases
alias dprint='docker run --rm -v $PWD:/mnt -w /mnt jpiraguha/dprint:0.9.0'
dprint fmt --config dprintrc.json
