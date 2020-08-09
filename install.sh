#!/bin/bash

DENO_SCRIPT_REF="master"
DENO_SCRIPT_HOME=~/.deno-script
DENO_SCRIPT_BIN=~/.deno-script/bin
DENO_SCRIPT_URL="https://raw.githubusercontent.com/jiraguha/deno-script/$DENO_SCRIPT_REF/deno-script.sh"

echo "[INFO] removing existing deno-script directory at <$DENO_SCRIPT_HOME>..."
rm -fr $DENO_SCRIPT_HOME
echo "[INFO] creating deno-script home directory at <$DENO_SCRIPT_HOME>..."
mkdir -p $DENO_SCRIPT_BIN
cd $DENO_SCRIPT_HOME || exit
echo "[INFO] downloading deno-script from <https://raw.githubusercontent.com/jiraguha/deno-script, $DENO_SCRIPT_REF>..."
curl -O $DENO_SCRIPT_URL

echo "[INFO] creating deno-script executable..."
mv deno-script.sh ./bin/deno-script
cd bin || exit
chmod u+x deno-script

ZSHRC_LOCATION=~/.zshrc
BASH_PROFILE_LOCATION=~/.bash_profile

echo "[INFO] deno-script is partially installed with success.
Please copy the line bellow in your <$ZSHRC_LOCATION> or <$BASH_PROFILE_LOCATION> to finish the installation:

export DENO_SCRIPT_HOME=$DENO_SCRIPT_HOME
export DENO_SCRIPT_BIN=$DENO_SCRIPT_BIN
export PATH=\$PATH:\$DENO_SCRIPT_BIN

"

read -p "This can be done automatically for you? (yes|no) " AUTO_INSTALL_RESPONSE

if [[ $AUTO_INSTALL_RESPONSE == "no" ]]; then
    exit 0
fi

read -p "What shell do you use? (bash|zsh) " SHELL_RESPONSE


if [[ $SHELL_RESPONSE == "zsh" ]]; then
  echo "[INFO] Appending env variable and bin path to $ZSHRC_LOCATION"
  echo "
export DENO_SCRIPT_HOME=$DENO_SCRIPT_HOME
export DENO_SCRIPT_BIN=$DENO_SCRIPT_BIN
export PATH=\$PATH:\$DENO_SCRIPT_BIN
" >> $ZSHRC_LOCATION
elif [[ $SHELL_RESPONSE == "bash" ]]; then
  echo "[INFO] Appending env variable and bin path to $BASH_PROFILE_LOCATION"
  echo "
export DENO_SCRIPT_HOME=$DENO_SCRIPT_HOME
export DENO_SCRIPT_BIN=$DENO_SCRIPT_BIN
export PATH=\$PATH:\$DENO_SCRIPT_BIN
" >> $BASH_PROFILE_LOCATION
  source $BASH_PROFILE_LOCATION
else
  echo "[ERROR] You response is not support"
  exit 1
fi

echo "[INFO] installation of 🦕 completed."
