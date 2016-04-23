#!/usr/bin/env bash

echo "removing..."

brew uninstall nodenv  ; rehash

sudo rm -rf /usr/local/bin/npm \
            /usr/local/share/man/man1/node* \
            /usr/local/include/node \
            /usr/local/include/node_modules \
            /usr/local/lib/node \
            /usr/local/lib/node_modules \
            /usr/local/lib/dtrace/node.d \
	    /usr/local/var/nodenv \
	    ~/npm-packages \
	    ~/node_modules \
	    ~/.node \
	    ~/.nodenv \
            ~/.npm \
            ~/.node-gyp \
	    ~/.npm-packages \
	    ~/.node_repl_history \
            /opt/local/bin/node \
	    /opt/local/include/node \
            /opt/local/lib/node_modules

echo "installing..."

# get nodenv
  brew install nodenv  ; rehash
  export NODENV_ROOT=/usr/local/var/nodenv       # should also be in ~/.profile (FIRST)
  eval "$(nodenv init -)"                        # should also be in ~/.profile (SECOND)
# get node-build
  git clone https://github.com/OiNutter/node-build.git $(nodenv root)/plugins/node-build
  brew 
# example node versions being installed
  echo nodenv versions
  echo nodenv install 0.12.9
  echo nodenv install 5.4.0
  echo nodenv global  5.4.0
