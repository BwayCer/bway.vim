
" 設定儲存目錄路徑
if has('nvim')
  let g:recordSession_storePath = fnamemodify('~/.local/share/nvim/mySession', ':p')
else
  let g:recordSession_storePath = fnamemodify('~/.local/share/vim/mySession', ':p')
endif

" 會話文件代號
let s:defaultSessionFileName = 'Banana'
let g:sessionFileCodeInfo = {
  \    'c': 'Cupcake',
  \    'd': 'Donut',
  \    'e': 'Eclair',
  \    'f': 'Froyo',
  \  }

" 檢查儲存目錄是否存在，若不存在則創建新目錄
function! s:checkStorePath(storePath)
  let fileType = getftype(a:storePath)
  if fileType == ''
    call system('mkdir -p "' . a:storePath . '"')
    if v:shell_error != 0
      throw '無法創建存取會話紀錄的 "' . a:storePath . '" 目錄。'
    endif
  elseif fileType != 'dir'
    echo '請先移除非目錄文件 "' . a:storePath . '" 以利創建存取會話紀錄的目錄。'
  endif
endfunction

" 會話紀錄的儲存、恢復及刪除操作
" ```vim
" command! -nargs=* RecordSession :call recordSession#Operate(<f-args>)
" nmap <CR>rssc    :RecordSession save Cupcake<CR>
" nmap <CR>rsrc :RecordSession restore Cupcake<CR>
" nmap <CR>rsdc  :RecordSession delete Cupcake<CR>
" ```
function! recordSession#Operate(act, ...)
  let l:mark = get(a:, 1, '')

  " 取得會話文件路徑
  let l:sessionPath = g:recordSession_storePath . '/'
        \ . (empty(l:mark) ? 'main.vim' : 'mark_' . l:mark . '.vim')

  if a:act == 'save'
    " 儲存
    call s:checkStorePath(g:recordSession_storePath)
    exec 'mksession! ' . l:sessionPath
    echo 'OK 儲存成功'
  elseif a:act == 'restore'
    " 恢復
    if !filereadable(l:sessionPath)
      throw '找不到 "' . l:sessionPath . '" 會話紀錄文件。'
    endif

    1,$bdelete
    exec 'source ' . l:sessionPath
  elseif a:act == 'delete'
    " 刪除
    if filereadable(l:sessionPath)
      call system('rm "' . l:sessionPath . '"')
      if v:shell_error != 0
        echom '無法刪除 ' . l:sessionPath . ' 會話紀錄文件。'
      else
        echom '成功刪除 ' . l:sessionPath . ' 會話紀錄文件。'
      endif
    endif
  endif
endfunction

" 以交互方式執行會話紀錄的儲存、恢復及刪除操作
function! recordSession#Prompt(...)
  let l:mark = get(a:, 1, '')

  if empty(l:mark)
    let l:prompt = '選擇一個儲存名稱 (b: ' . s:defaultSessionFileName
    for [key, val] in items(g:sessionFileCodeInfo)
      let prompt .= ', ' . key . ': ' . val
    endfor
    let l:prompt .= ', n: nothing)[b] : '

    let l:markCode = input(l:prompt)
    echo ' '

    if l:markCode == 'n'
      return
    endif

    let l:mark = has_key(g:sessionFileCodeInfo, l:markCode)
          \ ? g:sessionFileCodeInfo[l:markCode] : s:defaultSessionFileName
  endif

  let l:prompt = '將 "' . l:mark . '" 會話文件'
      \ . ' 儲存(s)/恢復(r)/刪除(d) 呢？ (s/r/d)[nothing] : '

  let l:markCode = input(l:prompt)
  echo ' '
  if l:markCode == 's'
    call recordSession#Operate('save', l:mark)
  elseif l:markCode == 'r'
    call recordSession#Operate('restore', l:mark)
  elseif l:markCode == 'd'
    call recordSession#Operate('delete', l:mark)
  endif
endfunction

