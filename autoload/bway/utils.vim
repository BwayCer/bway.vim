
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
    if &ft != 'diff'
        let b:curcol = col('.')
        let b:curline = line('.')
        silent! %s/\v +$//
        silent! %s/(\s*\n)\+\%$//
        call cursor(b:curline, b:curcol)
    endif
endfunction

" 註解/反註解 (單行) 選取範圍
" https://vi.stackexchange.com/questions/4366
function! bway#utils#Comment(method)
    if !has_key(s:fileCommentList, &filetype)
        echo '沒有 ' . &filetype . ' 文件類型的註解資訊'
        return
    endif

    silent! normal! zO

    let l:symbol = s:fileCommentList[&filetype]
    if a:method == 1
        exec 'silent! s/\(\S\)/' . l:symbol . ' \1/'
    else
        exec 'silent! s/^\(\s*\)' . l:symbol . ' /\1/'
    endif
endfunction
let s:fileCommentList = {}
let s:tmpFileCommentList = [
    \ ['"', 'vim'],
    \ ['#', 'sh', 'yaml', 'dockerfile'],
    \ ['\/\/', 'javascript', 'scss', 'dart', 'go'],
\ ]
for s:tmpFileComment in s:tmpFileCommentList
    let s:tmpCommentSymbol = s:tmpFileComment[0]
    for s:tmpFileType in s:tmpFileComment[1:]
        let s:fileCommentList[s:tmpFileType] = s:tmpCommentSymbol
    endfor
endfor

