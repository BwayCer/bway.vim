" 狀態列


" 設定樣式
set statusline=%1*[B%{bway#statusLine#GetBufFileTotal()}-%n]%m%*
set statusline+=%9*\ %y%r%*
set statusline+=%8*\ %{bway#statusLine#GetFileSize(@%)}\ %*
set statusline+=%<%7*\ %{&ff}\ \|\ %{\"\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\")}\ %*
set statusline+=%3*\ %F\ %*
set statusline+=%7*%=%*
set statusline+=%8*\ %3.(%c%V%)\ %*
set statusline+=%9*\ %l/%L\(%P\)\ %*


" 設定顏色
hi User5 cterm=None ctermfg=202 ctermbg=237
hi User7 cterm=None ctermfg=237 ctermbg=250
hi User8 cterm=None ctermfg=255 ctermbg=243
hi User9 cterm=None ctermfg=250 ctermbg=237

function! s:changeInsertMode(isInsert)
    if a:isInsert
        hi User1 cterm=None ctermfg=165 ctermbg=228
        hi User3 cterm=bold ctermfg=165 ctermbg=228
    else
        hi User1 cterm=None ctermfg=172 ctermbg=195
        hi User3 cterm=bold ctermfg=172 ctermbg=195
    endif
endfunction
autocmd InsertEnter * call s:changeInsertMode(1)
autocmd InsertLeave * call s:changeInsertMode(0)
call s:changeInsertMode(0)

