#!/bin/bash
shopt -s expand_aliases
alias bats-docker='docker run --rm -v $PWD:/home -w /home jpiraguha/deno-bats:deno-1.2.2_bats-1.2.1'
bats-docker test/deno-script-test.bats
