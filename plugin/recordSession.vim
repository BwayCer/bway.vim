" Vim 會話紀錄
" 打包當前 Vim 的狀態，將其儲存或恢復。


" 設定儲存目錄路徑
let g:bway_recordSession_storePath = '~/.vim/mySession'

command! -nargs=* BwayRecordSession :call bway#recordSession#Operate(<f-args>)


" 以交互方式詢問主會話的紀錄操作
function! s:mainSessionPrompt(act)
    let l:sessionPath = g:bway_recordSession_storePath . '/main.vim'
    if !empty(findfile(l:sessionPath))
        if a:act == 'save'
            if input('是否保存本次的會話群組？ (y: Yes, n: No)[n] : ') == 'y'
                BwayRecordSessionSave
            endif
            return
        elseif a:act == 'restore'
            if input('是否恢復上次的會話群組？ (y: Yes, n: No)[n] : ') == 'y'
                BwayRecordSessionRestore
            elseif input('是否清除上次的會話群組？ (y: Yes, n: No)[n] : ') == 'y'
                BwayRecordSessionRemove
            endif
        endif
    endif
endfunction

autocmd VimLeavePre * :call s:mainSessionPrompt('save')
autocmd VimEnter    * :call s:mainSessionPrompt('restore')

