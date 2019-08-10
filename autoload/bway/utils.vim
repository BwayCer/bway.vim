
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

