
" >> bway 程式包設置 -------

  let g:bway_getVar_conf = {}

  " 取得設定變數值
  function! BwayGetVar(name)
    return canUtils#GetVar('bway', a:name)
  endfunction


" Plug singleFile/utils

  " 側邊欄開關
  nmap <CR>side :call utils#SideRowNumberToggle()<CR>


  " 設定縮排
  command! -nargs=* SetIndentTabWidth :call utils#SetIndentTabWidth(<f-args>)

    nmap <CR>tab  :SetIndentTabWidth
    nmap <CR>tab2 :SetIndentTabWidth 2<CR>
    nmap <CR>tab4 :SetIndentTabWidth 4<CR>
    nmap <CR>tab8 :SetIndentTabWidth 8<CR>

  autocmd! FileType * :call utils#AutoSetIndentTabWidth()


  " 註解/反註解選取行
  map <CR>/ :call utils#Comment(0)<CR>
  map <CR>? :call utils#Comment(1)<CR>


  " 刪除多餘空白
  "   程式碼風格格式化 'Chiel92/vim-autoformat' 包含了此功能
  "   不過其功能過於強硬
  nmap <CR>rfs :call utils#RemoveTrailingSpace()<CR>
  " autocmd BufWritePre * call utils#RemoveTrailingSpace()


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

