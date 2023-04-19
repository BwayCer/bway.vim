
" 設定縮排寬度
function! bway#utils#SetIndentTabWidth(width)
  let &tabstop = a:width
  let &shiftwidth = a:width
  " echo '以 ' . a:width . ' 個單位縮排'
endfunction
" 自動依文件類型設定縮排寬度
function! bway#utils#AutoSetIndentTabWidth()
  if !has_key(g:fileIndentTabWidthInfo, &filetype)
    echo '沒有 ' . &filetype . ' 文件類型的縮排資訊'
    return
  endif

  let l:width = g:fileIndentTabWidthInfo[&filetype]
  echo &filetype . ' 文件類型的縮排為 ' . l:width
  call bway#utils#SetIndentTabWidth(l:width)
endfunction


" 側邊欄開關
" 這邊有個 py 範例捨不得刪
"   @requires sideRowNumber.py
"   let ynEnable = py3eval('bway_sideRowNumber_isEnable(' . bufnr('%') . ')')
let g:fileSideRowNumberToggleInfo = {}
function! bway#utils#SideRowNumberToggle()
  let l:bufnrKey = bufnr('%')

  echo l:bufnrKey
  if !has_key(g:fileSideRowNumberToggleInfo, l:bufnrKey)
        \ || g:fileSideRowNumberToggleInfo[l:bufnrKey] == 1
    let l:ynEnable = 0
  else
    let l:ynEnable = 1
  endif

  if l:ynEnable == 0
    set nonumber
    set norelativenumber
    set nofoldenable
    set foldcolumn=0
  else
    set number
    set relativenumber
    set foldenable
    set foldcolumn=2
  endif
  let g:fileSideRowNumberToggleInfo[l:bufnrKey] = l:ynEnable
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
  if !has_key(g:fileCommentInfo, &filetype)
    echo '沒有 ' . &filetype . ' 文件類型的註解資訊'
    return
  endif

  silent! normal! zO

  let l:symbol = g:fileCommentInfo[&filetype]
  if a:method == 1
    exec 'silent! s/\(\S\)/' . l:symbol . ' \1/'
  else
    exec 'silent! s/^\(\s*\)' . l:symbol . ' /\1/'
  endif
endfunction

