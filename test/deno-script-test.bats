#!/bin/bash
load some
load ../deno-script.sh --test
@test "invoking foo without arguments prints usage" {
  hello
  handleArguments --allow-read --allow-write -p edede
  echo "==================="
  echo ":$output"
  echo ":$expo"
  echo ":$permissionCatch"
  echo "==================="
 [ "$expo" = "Hello man" ]
 [ "$permissionCatch" = "--allow-read --allow-write" ]
}
