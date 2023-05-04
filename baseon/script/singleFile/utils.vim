
" >> 側邊欄開關 -------

  let s:fileSideRowNumberToggleInfo = {}

  function! utils#SideRowNumberToggle()
    let l:bufnrKey = bufnr('%')

    if !has_key(s:fileSideRowNumberToggleInfo, l:bufnrKey)
      let l:ynEnable = &number || &relativenumber || &foldenable ? 0 : 1
      echo 'no:' . l:ynEnable
    elseif s:fileSideRowNumberToggleInfo[l:bufnrKey] == 1
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
    let s:fileSideRowNumberToggleInfo[l:bufnrKey] = l:ynEnable
  endfunction


" >> 縮排 -------

  " 設定縮排寬度
  let g:fileIndentTabWidthInfo = {}

  let s:defaultFileIndentTabWidthInfo = {}
  let s:tmpSetItemList = [
        \   [2, 'markdown', 'vim', 'sh', 'ps1',
        \       'json', 'yaml',
        \       'javascript', 'dart',
        \       'pug', 'css', 'scss',
        \       'vue'],
        \   [4, 'dockerfile', 'python'],
        \   [8, 'go'],
        \ ]
  for s:tmpSetItem in s:tmpSetItemList
    for s:tmpItem in s:tmpSetItem[1:]
      let s:defaultFileIndentTabWidthInfo[s:tmpItem] = s:tmpSetItem[0]
    endfor
  endfor

  " 自動依文件類型設定縮排寬度
  "   set `autocmd! FileType * :call utils#AutoSetIndentTabWidth()`
  function! utils#AutoSetIndentTabWidth()
    if has_key(g:fileIndentTabWidthInfo, &filetype)
      let l:width = g:fileIndentTabWidthInfo[&filetype]
    elseif has_key(s:defaultFileIndentTabWidthInfo, &filetype)
      let l:width = s:defaultFileIndentTabWidthInfo[&filetype]
    else
      echo '沒有 ' . &filetype . ' 文件類型的縮排資訊'
      return
    endif

    echo &filetype . ' 文件類型的縮排為 ' . l:width
    let &tabstop = l:width
    let &shiftwidth = l:width
  endfunction

  " 手動設定縮排寬度
  function! utils#SetIndentTabWidth(width)
    echo '以 ' . a:width . ' 個單位縮排'
    let &tabstop = a:width
    let &shiftwidth = a:width
  endfunction


" >> 註解 -------

  " 設定註解字符
  let g:fileCommentInfo = {}

  let s:defaultFileCommentInfo = {}
  let s:tmpSetItemList = [
        \   ['"', 'vim'],
        \   ['#', 'sh', 'ps1', 'make', 'python', 'yaml', 'dockerfile'],
        \   ['\/\/', 'javascript', 'dart', 'go',
        \         'pug', 'scss', 'solidity', 'vue'],
        \ ]
  for s:tmpSetItem in s:tmpSetItemList
    for s:tmpItem in s:tmpSetItem[1:]
      let s:defaultFileCommentInfo[s:tmpItem] = s:tmpSetItem[0]
    endfor
  endfor

  " 註解/反註解 (單行) 選取範圍
  "   https://vi.stackexchange.com/questions/4366
  function! utils#Comment(method)
    if has_key(g:fileCommentInfo, &filetype)
      let l:symbol = g:fileCommentInfo[&filetype]
    elseif has_key(s:defaultFileCommentInfo, &filetype)
      let l:symbol = s:defaultFileCommentInfo[&filetype]
    else
      echo '沒有 ' . &filetype . ' 文件類型的註解資訊'
      return
    endif

    silent! normal! zO

    if a:method == 1
      exec 'silent! s/\(\S\)/' . l:symbol . ' \1/'
    else
      exec 'silent! s/^\(\s*\)' . l:symbol . ' /\1/'
    endif
  endfunction


" >> -------

  " 刪除多餘空白
  function! utils#RemoveTrailingSpace()
    if &ft != 'diff'
      let b:curcol = col('.')
      let b:curline = line('.')
      silent! %s/\v +$//
      silent! %s/(\s*\n)\+\%$//
      call cursor(b:curline, b:curcol)
    endif
  endfunction

