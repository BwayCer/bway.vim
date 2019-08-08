" 罐頭工具


" 取得 vim 程式包目錄
function canUtils#GetDirVi(mods)
    return fnamemodify(resolve(expand('<sfile>:p')), a:mods)
endfunction

" 取得設定值
" 程式包有可能以延遲的方式載入，因此可避免覆蓋過使用者的設定值
function! canUtils#GetVar(prifix, name)
    let l:result = get(g:, a:prifix . '_' . a:name)
    if !empty(l:result)
        return l:result
    endif

    let l:conf = get(g:, a:prifix . '_getVar_conf')
    if empty(l:conf)
        return 0
    endif

    return get(l:conf, a:name, 0)
endfunction


" 載入文件
function! canUtils#ImportFile(originPath, findExpr, execExpr)
    let l:findFile = globpath(a:originPath, a:findExpr)
    let l:fileList = filter(split(l:findFile, '\n'), '!isdirectory(v:val)')

    for l:filePath in l:fileList
        exec a:execExpr . l:filePath
    endfor
endfunction

" 載入 vim 文件
function! canUtils#ImportVim(pluginPath, ...)
    let l:expr = get(a:, 1, '*.vim')
    call canUtils#ImportFile(a:pluginPath, l:expr, 'source ')
endfunction

" 載入 python 文件
function! canUtils#ImportPython(pyLibPath, ...)
    let l:expr = get(a:, 1, '*.py')
    call canUtils#ImportFile(a:pyLibPath, l:expr, 'py3file ')
endfunction

" 運行命令行命令
function! canUtils#Sh(command, ...)
    let l:cmdTxt = '"' . canUtils#SafeQuote(a:command) . '"'
    for l:argu in a:000
        let l:cmdTxt .= ' "' . canUtils#SafeQuote(l:argu) . '"'
    endfor
    return system(l:cmdTxt)
endfunction


" 以反斜線編碼文字中的引號
function! canUtils#SafeQuote(txt)
    let l:symbolList = ['\', '"']
    let l:expr = a:txt
    for l:pat in l:symbolList
        let l:expr = substitute(l:expr, l:pat, '\\\' . l:pat, 'g')
    endfor
    return l:expr
endfunction

