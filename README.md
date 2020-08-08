# deno-script 🦕
[![Maturity badge - Experimental](https://img.shields.io/badge/Maturity-Experimental-yellow.svg)](https://github.com/jiraguha/deno-script/blob/master/maturity.md)


Enhanced scripting support for JavaScript/TypeScript with Deno 🦕 on *nix-based systems.

It is largely inspired by [kscript](https://github.com/holgerbrandl/kscript). The idea is to leverage the scripting abilities of javascript using [Deno](https://deno.land/).  

I feel that scripting can be so much fun with `Deno` as:

- It can import modules from any location on the web,
- It is secure by default. Imported module can run in sandbox.
- It is Supports TypeScript out of the box.
- It is much more that `Node`

## Requirement
- Installing deno.
- Os: Mac, linux
- Make sure that Deno is on the bin path
## Script Input Modes
The main mode of operation is `deno run <script>`.
The <script> can be a Javascript *.js or Typescritpt *.ts file , a script URL, `-` for stdin, a process substitution file handle.
### Interpreter Usage
To use Deno as interpreter for a script:
- create an executable in the bin directory `/usr/local/bin` called `deno-script`(call it as you want)
```shell
#!/bin/bash
#In deno-script
deno run $@
```
Make it executable
```
$ chmod u+x deno-script;
```
- Now when create a script just point to`deno-script` in the shebang line of your scripts:
```js
#!/usr/bin/env deno-script
// In hello.js
console.log("hello world")
for (let arg of Deno.args) {
    console.log(`arg: ${arg}`)
}
```
Make it executable
```
$ chmod u+x hello.js;
```
Execute it
```
$ ./hello.js;
```

You can me a similar script doing the `ls`job using Deno API’s!

```js
#!/bin/bash deno-script

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
    at file:///Users/jpi/dev/deno/deno-ls.js:3:29
```

This is were Deno shine! Deno will not you implicitly have access to to your directories. You need to explicitly ask the permission to Deno.

Your could specify it in the shebang:

```
#!/bin/bash deno-script --allow-read
```

For more about Deno security go [here](https://deno.land/manual/getting_started/permissions).

### Inlined Usage
To use kscript in a workflow without creating an additional script file, you can also use one of its supported modes for /inlined usage/. 

For the we will modify `deno-script` a bit

```shell
#!/bin/bash
if [[ $1 =~ (--inline|-i) ]]; then
    deno run <(echo $2) "${@:3}"
elif [[ $1 =~ (--pipe|-p) ]]; then
    while read arg; do
        deno run <(echo $2) "$arg"
    done
else
    deno run $@
fi
```

The following modes are supported:

- Directly provide a js scriptlet as argument
```
$ deno-script -i "console.log('hello', Deno.args[0])" JP
```
I can use pipe with it
```
 ls | xargs -L 1 deno-script -i 'console.log(`file:   ${Deno.args[0]}`)'
```
  `-L 1` of options of `xargs` is to manage the execution of each stream pipe elements ([see](https://unix.stackexchange.com/questions/7558/execute-a-command-once-per-line-of-piped-input))

You could get the same result with `-p`of `--p` option
```
ls -la | deno-script -p "console.log('hello', Deno.args[0])"
```

You can manage  several arguments
```
deno-script -i '
for (let arg of Deno.args) {
    console.log(`arg: ${arg}`)
} ' arg1 arg2 arg3
```

- Pipe a js snippet into Deno and instruct it to read from stdin by using - as script argument
```
echo '
console.log("hello world")
' | deno-script -
```
- Using heredoc (preferred solution for inlining) which gives you some more flexibility to also use single quotes in your script:
```
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


We could continue and do much more…


**Developed with for 🦕 with ❤️ **
