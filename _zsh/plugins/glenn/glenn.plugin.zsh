# loaded from .zshrc (by putting 'glenn' in the plugins array)

x() { cd ~/src/$1; }
_x() { _files -W ~/src -/; } 
compdef _x x

S() { cd ~/Sites/$1; }
_S() { _files -W ~/Sites -/; } 
compdef _S S
