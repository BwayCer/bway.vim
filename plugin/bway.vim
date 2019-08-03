
let s:_dirvi = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')

call bway#utils#ImportPython(s:_dirvi . '/lib.py3/')

