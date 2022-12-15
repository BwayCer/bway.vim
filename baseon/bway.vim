

" >> bway 程式包設置 -------

  let g:bway_getVar_conf = {}

  " 取得設定變數值
  function! BwayGetVar(name)
    return canUtils#GetVar('bway', a:name)
  endfunction


" >> 基礎設置 -------

  filetype plugin on
  set fileformat=unix
  set enc=utf8
  syntax on

  " 顯示命令列補全可能的匹配
  set wildmenu

  " 滑鼠功能只在 Visual 模式下使用
  set mouse=v
  " 在 insert 模式啟用 backspace 鍵
  set backspace=2

  " 保留 33 個歷史指令
  set history=33

  " 顯示行號
  set number
  " 顯示相對行號
  set relativenumber

  " 高亮游標行 (水平)
  set cursorline
  " 高亮游標行列 (垂直)
  set cursorcolumn
  " 游標形狀 (感覺會有失效的物件)
  set guicursor=n:ver25,v-sm:block,i-c-ci-ve:ver30-iCursor-blinkwait300-blinkon200-blinkoff150,r-cr-o:hor20

  " 顯示右下角的 行,列 目前在文件的位置 % 的資訊
  set ruler


" >> 縮排 -------

  " 使用 \t 的 Tab
  " set noexpandtab
  " 使用空白的 Tab
  set expandtab
  " 縮排 (Tab) 位元數
  set tabstop=4
  set shiftwidth=4
  " 依照檔案類型自動決定縮排樣式
  " filetype indent on

    nmap <CR>pas :set paste<CR>
    nmap <CR>pno :set nopaste<CR>

    nmap <CR>tab  :BwaySetIndentTabWidth
    nmap <CR>tab2 :BwaySetIndentTabWidth 2<CR>
    nmap <CR>tab4 :BwaySetIndentTabWidth 4<CR>
    nmap <CR>tab8 :BwaySetIndentTabWidth 8<CR>

  " 自動縮排
  set ai

  " 設定縮排
  command! -nargs=* BwaySetIndentTabWidth :call bway#utils#SetIndentTabWidth(<f-args>)
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


" >> 註解 -------

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
  noremap <CR>/ :call bway#utils#Comment(0)<CR>
  noremap <CR>? :call bway#utils#Comment(1)<CR>


" >> 風格配置 -------

  " 啟用暗色背景模式
  set background=dark

  " 設定行號為：粗體，前景色為深灰色，沒有背景色
  hi LineNr cterm=bold ctermfg=DarkGrey ctermbg=NONE
  hi Constant cterm=underline ctermfg=207 guifg=#ffa0a0

  " vim diff
  highlight DiffChange term=bold ctermbg=52 guibg=DarkMagenta
  highlight DiffText   term=reverse cterm=bold ctermbg=162 gui=bold guibg=Red


" >> 狀態列 -------

  " 開啟狀態列
  set laststatus=2

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


" >> 緩衝區與切割視窗 -------

  " 儲存文件
  nmap <CR>s :w<CR>
  " 退出文件
  nmap <CR>q :q<CR>

  " 緩衝區列表
  nmap <CR>bl :ls<CR>
  " 前一個開啟的緩衝區
  nmap <CR>bm :b#<CR>
  " 上一個緩衝區
  nmap <CR>bk :bp<CR>
  " 下一個緩衝區
  nmap <CR>bj :bn<CR>

  " 解除安裝緩衝區
  nmap <CR>bd :bd<CR>

  " 順序地切換視窗
  nmap <CR>ww <C-w>w
  " 移動至左側的視窗
  nmap <CR>wh <C-w>h
  " 移動至下方的視窗
  nmap <CR>wj <C-w>j
  " 移動至上方的視窗
  nmap <CR>wk <C-w>k
  " 移動至右側的視窗
  nmap <CR>wl <C-w>l

  " 加寬視窗 [Num]
  nmap <CR>wrw :vertical resize +
  " 縮寬視窗 [Num]
  nmap <CR>wrW :vertical resize -
  " 加高視窗 [Num]
  nmap <CR>wrh :resize +
  " 縮高視窗 [Num]
  nmap <CR>wrH :resize -

  " 分頁列表
  nmap <CR>wtl :tabs<CR>
  " 新增分頁
  nmap <CR>wte :tabedit<CR>
  " 上一分頁
  nmap <CR>wtp :tabNext<CR>
  " 下一分頁
  nmap <CR>wtn :tabnext<CR>
  nmap z/wtn :tabnext<CR>


" >> 會話紀錄 -------
  " 打包當前 Vim 的狀態，將其儲存或恢復。

  " 設定儲存目錄路徑
  let g:bway_getVar_conf.recordSession_storePath = g:vimDir . '/localShare/mySession'

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


" >> 特殊動作 -------

  " 自動切換當前路徑至文件目錄
  set autochdir

  " 對當前文件目錄操作
  nmap <CR>dir :browse new .

  " 字數過長時換行
  set wrap
  " 捲動時保留底下 3 行
  set scrolloff=3

  " 摺疊 Folding
  set foldenable          " 啟用命令
  set foldcolumn=2        " 於左側欄上顯示 1 格寬的摺疊標誌訊息
  set foldmethod=indent
  set foldlevel=5         " method=indent

    " 依 shiftwidth 的縮排方式摺疊
    nmap <CR>fmi :set foldmethod=indent<CR>
    " 手動摺疊
    nmap <CR>fmm :set foldmethod=manual<CR>

  " 側邊欄開關

    nmap <CR>side :call bway#utils#SideRowNumberToggle()<CR>

  " 插入模式補全
  " :h ins-completion
  " <C-x><C-o> 為預設的補齊按键组合 (keyword: omnifunc)
  imap <C-a>l <C-x><C-l>
  imap <C-a>n <C-x><C-n>
  imap <C-a>k <C-x><C-k>
  imap <C-a>t <C-x><C-t>
  imap <C-a>i <C-x><C-i>
  imap <C-a>] <C-x><C-]>
  imap <C-a>f <C-x><C-f>
  imap <C-a>d <C-x><C-d>
  imap <C-a>v <C-x><C-v>
  imap <C-a>u <C-x><C-u>
  imap <C-a>o <C-x><C-o>
  imap <C-a>s <C-x><C-s>

  " 搜尋
  set incsearch       " 即時的關鍵字匹配 不須等到完全輸入完才顯示結果
  set hlsearch        " 標記關鍵字
  set ic              " 搜尋不分大小寫

  " vimgrep 搜尋

    nmap <CR>sr  :grep -rin
    nmap <CR>cp  :cp<CR>
    nmap <CR>cn  :cn<CR>
    nmap <CR>cfp :cpf<CR>
    nmap <CR>cfn :cnf<CR>
    nmap <CR>clo :copen<CR>
    nmap <CR>clc :cclose<CR>
    nmap <CR>clp :col<CR>
    nmap <CR>cln :cnew<CR>

  " 刪除多餘空白
  " 程式碼風格格式化 'Chiel92/vim-autoformat' 包含了此功能
  " 不過其功能過於強硬
  " autocmd BufWritePre * call bway#utils#RemoveTrailingSpace()
  nmap <CR>rfs :call bway#utils#RemoveTrailingSpace()<CR>

