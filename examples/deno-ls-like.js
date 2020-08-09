#!/bin/bash deno-script --allow-read

for (const dirEntry of Deno.readDirSync("./")) {
      console.log(dirEntry.name);
}