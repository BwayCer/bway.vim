
" >> bway 程式包設置 -------

  let g:bway_getVar_conf = {}

  " 取得設定變數值
  function! BwayGetVar(name)
    return canUtils#GetVar('bway', a:name)
  endfunction


" Plug bway

  " 設定縮排
  command! -nargs=* BwaySetIndentTabWidth :call bway#utils#SetIndentTabWidth(<f-args>)

    nmap <CR>tab  :BwaySetIndentTabWidth
    nmap <CR>tab2 :BwaySetIndentTabWidth 2<CR>
    nmap <CR>tab4 :BwaySetIndentTabWidth 4<CR>
    nmap <CR>tab8 :BwaySetIndentTabWidth 8<CR>

  let g:fileIndentTabWidthInfo = {}
  let s:tmpSetItemList = [
        \   [2, 'sh', 'vim', 'markdown',
        \       'json', 'yaml',
        \       'javascript', 'dart',
        \       'pug', 'css', 'scss',
        \       'vue'],
        \   [4, 'dockerfile', 'python'],
        \   [8, 'go'],
        \ ]
  for s:tmpSetItem in s:tmpSetItemList
    for s:tmpItem in s:tmpSetItem[1:]
      let g:fileIndentTabWidthInfo[s:tmpItem] = s:tmpSetItem[0]
    endfor
  endfor
  autocmd! BufReadPost * :call bway#utils#AutoSetIndentTabWidth()


  " 設定註解字符
  let g:fileCommentInfo = {}
  let s:tmpSetItemList = [
        \   ['"', 'vim'],
        \   ['#', 'sh', 'make', 'python', 'yaml', 'dockerfile'],
        \   ['\/\/', 'javascript', 'dart', 'go',
        \         'pug', 'scss', 'solidity', 'vue'],
        \ ]
  for s:tmpSetItem in s:tmpSetItemList
    for s:tmpItem in s:tmpSetItem[1:]
      let g:fileCommentInfo[s:tmpItem] = s:tmpSetItem[0]
    endfor
  endfor

  " 註解/反註解選取行
  map <CR>/ :call bway#utils#Comment(0)<CR>
  map <CR>? :call bway#utils#Comment(1)<CR>


  " 側邊欄開關
  nmap <CR>side :call bway#utils#SideRowNumberToggle()<CR>


  " 刪除多餘空白
  " 程式碼風格格式化 'Chiel92/vim-autoformat' 包含了此功能
  " 不過其功能過於強硬
  " autocmd BufWritePre * call bway#utils#RemoveTrailingSpace()
  nmap <CR>rfs :call bway#utils#RemoveTrailingSpace()<CR>


" Plug bway: 會話紀錄
  " 打包當前 Vim 的狀態，將其儲存或恢復。

  " 設定儲存目錄路徑
  if has('nvim')
    let g:bway_getVar_conf.recordSession_storePath = '~/.local/share/nvim/mySession'
  else
    let g:bway_getVar_conf.recordSession_storePath = '~/.local/share/vim/mySession'
  endif

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


  " :help sessionoptions
  set sessionoptions-=curdir
  set sessionoptions+=sesdir

  nmap <CR>rss    :BwayRecordSession save goo
  nmap <CR>rsr :BwayRecordSession restore goo
  nmap <CR>rsd  :BwayRecordSession delete goo
  nmap <CR>rssc    :BwayRecordSession save Cupcake<CR>
  nmap <CR>rsrc :BwayRecordSession restore Cupcake<CR>
  nmap <CR>rsdc  :BwayRecordSession delete Cupcake<CR>
  nmap <CR>rssd    :BwayRecordSession save Donut<CR>
  nmap <CR>rsrd :BwayRecordSession restore Donut<CR>
  nmap <CR>rsdd  :BwayRecordSession delete Donut<CR>
  nmap <CR>rsse    :BwayRecordSession save Eclair<CR>
  nmap <CR>rsre :BwayRecordSession restore Eclair<CR>
  nmap <CR>rsde  :BwayRecordSession delete Eclair<CR>

