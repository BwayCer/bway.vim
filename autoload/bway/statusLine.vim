
" 取得計算已開啟的緩存文件數量
function! bway#statusLine#GetBufFileTotal()
    return len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
endfunction

" 取得可閱讀的文件大小
function! bway#statusLine#GetFileSize(fileName)
    let l:size = getfsize(expand(a:fileName))

    if l:size == 0 || l:size == -1 || l:size == -2
        return '[Empty]'
    endif

    if l:size < 1024
        return l:size . 'b'
    elseif l:size < 1024*1024
        return printf('%.1f', l:size/1024.0) . 'K'
    elseif l:size < 1024*1024*1024
        return printf('%.1f', l:size/1024.0/1024.0) . 'M'
    else
        return printf('%.1f', l:size/1024.0/1024.0/1024.0) . 'G'
    endif
endfunction

