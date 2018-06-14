cat $0 | tailplus 3 | less; exit

SHELL (http://www.tldp.org/LDP/Bash-Beginners-Guide/html)

  FUNCNAME[]    - call stack of functions
  BASH_SOURCE[] - call stack of files
  funcfiletrace[] - ZSH: call stack of files (see also funcsourcetrace, funcstack functrace)

  history
    asterisk in history means it was editted
      ^_ while navigating back through history will show the original command, then
         you can then execute it
  braces to group block of code (in the CURRENT shell)
    { date; ls; } > logfile
  brace expression with comma {,}
    echo f{oo,ee,a}d
      food feed fad
    mv error.log{,.OLD}
      # mv error.log error.log.OLD
  brace range expansion with mini-elipses {..}
    for num in {000..2}; do echo "$num"; done
      000
      001
      002
    echo {00..8..2}
      00 02 04 06 08
    echo {D..T..4}
      D H L P T
    note that you can't use a vaiable in a range, so use 'for((' instead

  substitutions ${//}
    # substitute "de" in string with "12"
    echo ${var/de/12}

  default values ${:-}
    default="hello"
    unset var
    echo ${var:-$default}
    hello

  double parents for arithmetic:
  ((a++))
  ((meaning = 42))
  for ((i=0; i<10; i++))
        ((a + b + (14 * c)))
  echo $((a + b + (14 * c)))

  arrays
    ar=(1 2 3)
    ((ar[4]=3))
    echo ${ar[1]}
    echo ${#array[@]}  # size of the array

  quotes
      mkdir "a b"
      ls -d  $(echo "a b")  #fails, as expected
      ls -d "$(echo "a b")" #surprisingly, this works!! (strange pairing of double quotes)
