# deno-script 🦕
Enhanced scripting support for JavaScript/TypeScript with Deno 🦕 on *nix-based systems.

[![Maturity badge - Experimental](https://img.shields.io/badge/Maturity-Experimental-yellow.svg)](https://github.com/jiraguha/deno-script/blob/master/maturity.md)

---

It is largely inspired by [kscript](https://github.com/holgerbrandl/kscript). The idea is to leverage the scripting abilities of javascript using [Deno](https://deno.land/).  

I feel that scripting can be so much fun with `Deno` as:

- It can import modules from any location on the web,
- It is secure by default. Imported module can run in sandbox.
- It is Supports TypeScript out of the box.
- It is much more that `Node`

## Requirement
- Os: Mac, linux
- [Installing deno](https://deno.land/#installation)
- Make sure that Deno is on the bin path. If you `homebrew` the last point should be done automatically. If not, make sure to manually add them to your `.bash_profile` (or similar)... see bellow!
```
# Add this to your .bash_profile
export DENO_INSTALL="$HOME/.deno"
export PATH=$PATH:$DENO_INSTALL/bin
```
## Installation

If your are on `zsh`:
```shell
curl -sSL "https://raw.githubusercontent.com/jiraguha/deno-script/master/install.sh" | bash -s "master" "zsh" 

```

For others:
```shell
curl -sSL "https://raw.githubusercontent.com/jiraguha/deno-script/master/install.sh" | bash -s "master" "bash"  

```


## Script Input Modes
The main mode of operation is `deno run <script>`.
The <script> can be a Javascript *.js or Typescript *.ts file , a script URL, `-` for stdin, a process substitution file handle.
### Interpreter Usage
To use Deno as interpreter for a script:
- Just create a script just point to`deno-script` in the shebang line of your scripts:
```js
#!/usr/bin/env deno-script
// In hello.js
console.log("hello world")
for (let arg of Deno.args) {
    console.log(`arg: ${arg}`)
}
```
Make it executable
```shell
$ chmod u+x hello.js;
```
Execute it
```shell
$ ./hello.js;
```

You can make a similar script doing the `ls`job using Deno API’s!

```js
#!/bin/bash deno-script
// In hello.js
for (const dirEntry of Deno.readDirSync("./")) {
      console.log(dirEntry.name);
}
```

If we execute this script, we will have a error

```
error: Uncaught PermissionDenied: read access to "./", run again with the --allow-read flag
    at unwrapResponse (rt/10_dispatch_json.js:25:13)
    at sendSync (rt/10_dispatch_json.js:52:12)
    at Object.readDirSync (rt/30_fs.js:105:16)
    at file:///Users/jpi/dev/deno/deno-ls-like.js:3:29
```

This is were Deno shine! Deno will not let you implicitly have access to your directories. You need to explicitly ask the permission to Deno.

You could specify it in the shebang:

```shell
#!/bin/bash deno-script --allow-read
```

For more about Deno security go [here](https://deno.land/manual/getting_started/permissions).

### Inlined Usage
To use kscript in a workflow without creating an additional script file, you can also use one of its supported modes for /inlined usage/. 

The following modes are supported:

- Directly provide a js scriptlet as argument
```shell
$ deno-script -i "console.log('hello', Deno.args[0])" JP
```
I can use pipe with it
```shell
 ls | xargs -L 1 deno-script -i 'console.log(`file:   ${Deno.args[0]}`)'
```
  `-L 1` of options of `xargs` is to manage the execution of each stream pipe elements ([see](https://unix.stackexchange.com/questions/7558/execute-a-command-once-per-line-of-piped-input))

You could get the same result with `-p`of `--pipe` option
```shell
ls -la | deno-script -p "console.log('hello', line)"
```
`line` give access to the stdin stream of the pipe.

You can manage  several arguments:
```shell
deno-script -i '
for (let arg of Deno.args) {
    console.log(`arg: ${arg}`)
} ' arg1 arg2 arg3
```

- Pipe a js snippet into Deno and instruct it to read from stdin by using - as script argument
```shell
echo '
console.log("hello world")
' | deno-script -
```
- Using heredoc (preferred solution for inlining) which gives you some more flexibility to also use single quotes in your script:
```shell
deno-script - <<"EOF"
console.log("It's a beautiful day!")
EOF
```

- Since the piped content is considered as a regular script it can also have dependencies
```shell
deno-script - <<"EOF"
  import {hello} from "https://raw.githubusercontent.com/jiraguha/js-playgroud/master/hello-lib.ts"
  hello("JP")
EOF
```

### Read Usage

The `colors.txt` used here is available [here](https://raw.githubusercontent.com/jiraguha/deno-script/master/examples/colors.txt)
- read a file line by line
```shell
 deno-script --read-file-line "console.log(line.split(';')[0])" colors.txt

```
`line` give access to each line

- read a file as an all
```shell
 deno-script --read-file "console.log(lines[0])" colors.txt
```
`lines` give access to all lines in iterable


- read a text line by line
```shell
 deno-script --read-text-line "console.log(line.split(';')[1])" \
"Viridian; #40826D; 64; 130; 109; 161; 51; 38
        Violet; #7F00FF; 127; 0; 255; 270; 100; 50
        Ultramarine; #3F00FF; 63; 0; 255; 255; 100; 50
        Turquoise; #40E0D0; 64; 224; 208; 174; 71; 56
        Teal; #008080; 0; 128; 128; 180; 100; 25"
```

OR 

```shell
cat colors.txt | xargs -0 deno-script --read-text-line "console.log(line.split(';')[1])" 
```

- read a text as an all
```shell
cat colors.txt | xargs -0 deno-script --read-text "console.log(lines[3])" 
```
## Roadmap

TODO

**Developed for 🦕 with ❤️**
