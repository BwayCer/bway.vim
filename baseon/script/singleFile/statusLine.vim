
" 取得計算已開啟的緩存文件數量
function! statusLine#GetBufFileTotal()
  return len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
endfunction

" 取得文件大小
function! statusLine#GetFileSize(fileName)
  let l:size = getfsize(expand(a:fileName))

  if l:size == 0 || l:size == -1 || l:size == -2
    return '[Empty]'
  endif

  if l:size < 1024
    let readableSize = l:size . 'b'
  elseif l:size < 1024*1024
    let readableSize = printf('%.1f', l:size/1024.0) . 'K'
  elseif l:size < 1024*1024*1024
    let readableSize = printf('%.1f', l:size/1024.0/1024.0) . 'M'
  else
    let readableSize = printf('%.1f', l:size/1024.0/1024.0/1024.0) . 'G'
  endif
  return ' ' . readableSize . ' '
endfunction

" 程式碼診斷 (搭配User5色塊)
function! StatusLine_CodeDiagnostic(fileName)
  return ''
endfunction


" NOTE:
"   當使用兩個相連的 `%{func()}` 時，若前者為可變長度
"   且接著的回傳值首字帶空白格文字，其空白格會消失。
" 設定樣式
set statusline=%1*[B%{statusLine#GetBufFileTotal()}-%n]%m%*
set statusline+=%5*%{StatusLine_CodeDiagnostic(@%)}%*
set statusline+=%9*%y%r%*
set statusline+=%8*%{statusLine#GetFileSize(@%)}%*
set statusline+=%<%7*\ %{&ff};%{\"\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\")}\ %*
set statusline+=%1*\ %F\ %*
set statusline+=%7*%=%*
set statusline+=%8*\ %3.(%c%V%)\ %*
set statusline+=%9*\ %l/%L\(%P\)\ %*


" 設定顏色
hi User5 cterm=None ctermfg=228 ctermbg=237
hi User7 cterm=None ctermfg=237 ctermbg=250
hi User8 cterm=None ctermfg=255 ctermbg=243
hi User9 cterm=None ctermfg=250 ctermbg=237

" 設定一般模式和輸入模式顏色
function! s:changeInsertMode(isInsert)
  if a:isInsert
    hi User1 cterm=None ctermfg=165 ctermbg=228
  else
    hi User1 cterm=None ctermfg=172 ctermbg=195
  endif
endfunction
autocmd InsertEnter * call s:changeInsertMode(1)
autocmd InsertLeave * call s:changeInsertMode(0)
call s:changeInsertMode(0)

