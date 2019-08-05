
" 取得設定值
" 程式包有可能以延遲的方式載入，因此可避免覆蓋過使用者的設定值
function! bway#utils#GetVar(name)
    let l:result = get(g:, 'bway_' . a:name)
    if !empty(l:result) " or l:result != '0'
        return l:result
    endif
    return get(g:bway_getVar_conf, a:name, 0)
endfunction


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


" 以反斜線編碼文字中的引號
function! bway#utils#SafeQuote(txt)
    return substitute(a:txt, '"', '\\\"', 'g')
endfunction


" 設定縮排寬度
function! bway#utils#SetIndentTabWidth(width)
    let &tabstop = a:width
    let &shiftwidth = a:width
    echo '以 ' . a:width . ' 個單位縮排'
endfunction

" 側邊欄開關
" @requires sideRowNumber.py
function! bway#utils#SideRowNumberToggle()
    let ynEnable = py3eval('bway_sideRowNumber_isEnable(' . bufnr('%') . ')')
    if ynEnable == 1
        set number
        set relativenumber
        set foldenable
        set foldcolumn=2
    else
        set nonumber
        set norelativenumber
        set nofoldenable
        set foldcolumn=0
    endif
endfunction


" 刪除多餘空白
function! bway#utils#RemoveTrailingSpace()
    if &ft != "diff"
        let b:curcol = col(".")
        let b:curline = line(".")
        silent! %s/\v +$//
        silent! %s/(\s*\n)\+\%$//
        call cursor(b:curline, b:curcol)
    endif
endfunction

