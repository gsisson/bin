    assoc .sh=bashscript
    ftype bashscript=C:\cygwin\bin\bash.exe --login -i -c 'cd "$(dirname "$(cygpath -u "%1")")"; bash "$(cygpath -u "%1")"'
rem ftype bashscript=C:\cygwin\bin\run.exe bash -li -c 'cd "$(dirname "$(cygpath -u "%1")")"; bash "$(cygpath -u "%1")"'
