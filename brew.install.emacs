#!/usr/bin/env bash

cat << EOF
  #
  # Installing Emacs on Mac
  #
  # Special instructions since "brew install emacs --with-cocoa" isn't supported anymore
  #
  #  1) from https://github.com/d12frosted/homebrew-emacs-plus
  #     brew tap d12frosted/emacs-plus
  #     brew install emacs-plus # very SLOW to build... maybe use some --without-* options
  #     # brew linkapps emacs-plus # unsupported
  #     ln -s /usr/local/opt/emacs-plus/Emacs.app /Applications
  #
  #  2) This works too, by just injecting the old code that brew used to install
  #     echo '# to get emacs...'
  #     echo '#   use this tarball of the old "brew install emacs --with-cocoa"'
  #     echo '#   untar ~/Dropbox/bin/emacs.cocoa/Applications=emacs=v26.2.with.cocoa.tar.gz'
  #     echo '#   mv Applications/Emacs.app /Applications'
  #     echo '#   ln -s /Applications/Emacs.app/Contents/MacOS/bin/emacs /usr/local/bin/emacs'
  #     echo '#   ln -s /Applications/Emacs.app/Contents/MacOS/bin/emacsclient /usr/local/bin/emacsclient'
EOF
