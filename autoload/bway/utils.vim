
" 載入文件
function! bway#utils#ImportFile(originPath, findExpr, execExpr)
    let l:findPyFile = globpath(a:originPath, a:findExpr)
    let l:pyFileList = filter(split(l:findPyFile, '\n'), '!isdirectory(v:val)')

    for l:filePath in l:pyFileList
        exec a:execExpr . l:filePath
    endfor
endfunction

" 載入 vim 文件
function! bway#utils#ImportVim(pluginPath, ...)
    let l:expr = get(a:, 1, '*.vim')
    call bway#utils#ImportFile(a:pluginPath, l:expr, 'source ')
endfunction

" 載入 python 文件
function! bway#utils#ImportPython(pyLibPath, ...)
    let l:expr = get(a:, 1, '*.py')
    call bway#utils#ImportFile(a:pyLibPath, l:expr, 'py3file ')
endfunction

