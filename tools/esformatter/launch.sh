#!/bin/bash
shopt -s expand_aliases
alias esformatter='docker run --rm -v $PWD:/mnt -w /mnt esformatter:0.11.3'
esformatter -i **/*.js
