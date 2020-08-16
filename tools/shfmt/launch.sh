#!/bin/bash
shopt -s expand_aliases
alias shfmt='docker run --rm -v $PWD:/mnt -w /mnt mvdan/shfmt:v3.1.2 -i 2 -ci'
shfmt -w .
