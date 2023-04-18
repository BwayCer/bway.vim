

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

  " 自動縮排
  set ai

  " 摺疊 Folding
  set foldenable          " 啟用命令
  set foldcolumn=2        " 於左側欄上顯示 1 格寬的摺疊標誌訊息
  set foldmethod=indent
  set foldlevel=5         " method=indent

    " 依 shiftwidth 的縮排方式摺疊
    nmap <CR>fmi :set foldmethod=indent<CR>
    " 手動摺疊
    nmap <CR>fmm :set foldmethod=manual<CR>


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


" >> 特殊動作 -------

  " 自動切換當前路徑至文件目錄
  set autochdir

  " 對當前文件目錄操作
  nmap <CR>dir :browse new .

  " 字數過長時換行
  set wrap
  " 捲動時保留底下 3 行
  set scrolloff=3

  " 貼上模式
  nmap <CR>pas :set paste<CR>
  nmap <CR>pno :set nopaste<CR>

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

