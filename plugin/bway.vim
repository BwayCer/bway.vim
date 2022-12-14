
let g:bway_getVar_conf = {}
let s:_dirvi = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')
" call canUtils#ImportPython(s:_dirvi . '/lib/')


    " 取得設定變數值
    function! BwayGetVar(name)
        return canUtils#GetVar('bway', a:name)
    endfunction


    " 設定縮排
    command! -nargs=* BwaySetIndentTabWidth :call bway#utils#SetIndentTabWidth(<f-args>)
    let g:fileIndentTabWidthInfo = {}
    let s:tmpSetItemList = [
        \ [2, 'sh', 'vim', 'markdown',
        \     'json', 'yaml',
        \     'javascript', 'dart',
        \     'pug', 'css', 'scss',
        \     'vue'],
        \ [4, 'dockerfile', 'python'],
        \ [8, 'go'],
    \ ]
    for s:tmpSetItem in s:tmpSetItemList
        for s:tmpItem in s:tmpSetItem[1:]
            let g:fileIndentTabWidthInfo[s:tmpItem] = s:tmpSetItem[0]
        endfor
    endfor
    autocmd BufReadPost * :call bway#utils#AutoSetIndentTabWidth()

    " 設定註解字符
    let g:fileCommentInfo = {}
    let s:tmpSetItemList = [
        \ ['"', 'vim'],
        \ ['#', 'sh', 'make', 'python', 'yaml', 'dockerfile'],
        \ ['\/\/', 'javascript', 'pug', 'scss', 'dart', 'go',
        \     'solidity', 'vue'],
    \ ]
    for s:tmpSetItem in s:tmpSetItemList
        for s:tmpItem in s:tmpSetItem[1:]
            let g:fileCommentInfo[s:tmpItem] = s:tmpSetItem[0]
        endfor
    endfor


" >> 狀態列 -------

    " 設定樣式
    set statusline=%1*[B%{bway#statusLine#GetBufFileTotal()}-%n]%m%*
    set statusline+=%9*%y%r%*
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


" >> Vim 會話紀錄 -------
    " 打包當前 Vim 的狀態，將其儲存或恢復。

    " 設定儲存目錄路徑
    let g:bway_getVar_conf.recordSession_storePath = fnamemodify('~', ':p') . '.vim/mySession'

    command! -nargs=* BwayRecordSession :call bway#recordSession#Operate(<f-args>)


    " 以交互方式詢問主會話的紀錄操作
    function! s:mainSessionPrompt(act)
        let l:sessionPath = BwayGetVar('recordSession_storePath') . '/main.vim'
        if !empty(findfile(l:sessionPath))
            if a:act == 'save'
                if input('是否保存本次的會話群組？ (y: Yes, n: No)[n] : ') == 'y'
                    BwayRecordSession save
                endif
                return
            elseif a:act == 'restore'
                if input('是否恢復上次的會話群組？ (y: Yes, n: No)[n] : ') == 'y'
                    BwayRecordSession restore
                elseif input('是否清除上次的會話群組？ (y: Yes, n: No)[n] : ') == 'y'
                    BwayRecordSession delete
                endif
            endif
        endif
    endfunction

    autocmd VimLeavePre * :call s:mainSessionPrompt('save')
    autocmd VimEnter    * :call s:mainSessionPrompt('restore')

