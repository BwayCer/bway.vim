
" 檢查儲存目錄是否存在，若不存在則創建新目錄
function! s:checkStorePath(storePath)
    if empty(finddir(a:storePath))
        call system('mkdir -p ' . bway#utils#SafeQuote(a:storePath))
        if v:shell_error != 0
            throw '無法創建 "' . a:storePath . '" 目錄用以存取會話紀錄。'
        endif
    endif
endfunction

" 取得會話文件路徑
function! s:getSessionPath(mark)
    if empty(a:mark)
        let l:markName = 'main.vim'
    else
        let l:markName = 'mark_' . a:mark . '.vim'
    endif
    return g:bway_recordSession_storePath . '/' . l:markName
endfunction

" 會話紀錄的儲存、恢復及刪除操作
function! bway#recordSession#Operate(method, ...)
    let l:mark = get(a:, 1, '')

    let l:sessionPath = s:getSessionPath(l:mark)

    if a:method == 'save'
        " 儲存
        call s:checkStorePath(g:bway_recordSession_storePath)
        exec 'mksession! ' . l:sessionPath
    elseif a:method == 'Restore'
        " 恢復
        if empty(findfile(l:sessionPath))
            throw '找不到 "' . l:sessionPath . '" 會話紀錄文件。'
        endif

        1,$bdelete
        exec 'source ' . l:sessionPath
    elseif a:method == 'delete'
        " 刪除
        if empty(findfile(l:sessionPath))
            echom '無法刪除不存在的 ' . l:sessionPath . ' 會話紀錄文件。'
        else
            call system('rm "'
                \ . bway#utils#SafeQuote(g:bway_recordSession_storePath)
                \ . '"')
            if v:shell_error != 0
                echom '無法刪除 ' . l:sessionPath . ' 會話紀錄文件。'
            else
                echom '成功刪除 ' . l:sessionPath . ' 會話紀錄文件。'
            endif
        endif
    endif
endfunction

