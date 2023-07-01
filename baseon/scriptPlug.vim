
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


" Plug singleFile/recordSession 會話紀錄
  " 打包當前 Vim 的狀態，將其儲存或恢復。

  " :help sessionoptions
  set sessionoptions-=curdir
  set sessionoptions+=sesdir

  " 設定儲存目錄路徑
  command! -nargs=* RecordSession :call recordSession#Prompt(<f-args>)

    nmap <CR>rsp :RecordSession<CR>
    nmap <CR>rsc :RecordSession Cupcake<CR>
    nmap <CR>rsd :RecordSession Donut<CR>
    nmap <CR>rse :RecordSession Eclair<CR>
    nmap <CR>rsf :RecordSession Froyo<CR>


" Plug singleFile/bwayCode

  nmap <CR>bcd :call bwayCode#Diagnostic()<CR>
  nmap <CR>bcr :call bwayCode#Run()<CR>

