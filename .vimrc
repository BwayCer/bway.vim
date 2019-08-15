" >> vim-plug 管理器 -------

" 指定放置插件的目錄
" - 避免去使用 Vim 的規範目錄名稱， 如：`plugin`
call plug#begin('~/.vim/bundle')

    " 請務必使用單引號

    " >> 起頭設置 -------

        nmap <silent> <CR>rvc :source ~/.vimrc<CR>

        nmap <CR>rvpi :PlugInstall<CR>
        nmap <CR>rvpu :PlugUpdate<CR>
        nmap <CR>rvpc :PlugClean<CR>
        " :PlugUpgrade   - 更新 vim-plug 管理器
        " :PlugInstall   - 安裝未安裝的插件
        " :PlugUpdate    - 安裝或更新插件
        " :PlugClean     - 移除未使用的插件目錄
        " :PlugStatus    - 查看目前插件狀態

        " 取消向下支援
        set nocompatible
        set t_Co=256


    " 中文說明文件
    Plug 'chusiang/vimcdoc-tw'

    " Vim 腳本的函式庫
    Plug 'vim-scripts/L9'

    " 查找文件 ； 依賴： L9
    Plug 'vim-scripts/FuzzyFinder'

        nmap Ff :FufFile<CR>
        nmap Fb :FufBuffer<CR>
        " nmap Fc :FufDir

    " 命令行著色
    Plug 'chrisbra/Colorizer'

        let s:numChangeColorSwitch = 0
        function! Bway_rewrite_ChangeColorToggle()
            let s:numChangeColorSwitch += 1
            if s:numChangeColorSwitch == 1
                ColorHighlight
            else
                let s:numChangeColorSwitch = 0
                ColorClear
            endif
        endfunction

        nmap <CR>rcc :call Bway_rewrite_ChangeColorToggle()<CR>

    " 程式碼目錄 需額外安裝 ctags
    Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }

        nmap <F8> :TagbarToggle<CR>

    " 標記減量預覽
    Plug 'BwayCer/markdown-preview.vim', { 'branch': 'linkInVm', 'for': 'markdown' }
    " autocmd! User markdown-preview.vim echo '[Bway.Plug] 標記減量預覽 已載入'

        nmap <CR>rmd :MarkdownPreview<CR>
        nmap <CR>rmdstop :MarkdownPreviewStop<CR>

    " Go 程式語言
    Plug 'fatih/vim-go'

        nmap <CR>gof   :GoFmt<CR>
        nmap <CR>gofmt :GoFmt<CR>
        nmap <CR>gor   :GoRun<CR>
        nmap <CR>gorun :GoRun<CR>

    " Go 程式語言 - 語法提示
    Plug 'nsf/gocode', { 'rtp': 'vim', 'do': '~/.vim/plugged/gocode/vim/symlink.sh' }

    " kiang: 打程式碼方塊
    Plug 'johngrib/vim-game-code-break'

        command KiangVimGameCodeBreak :call VimGameCodeBreak#game#main()

    " 命令由你
    Plug 'BwayCer/cmdbyu.vim'

        let g:cmdbyu_globalDirectory = fnamemodify('~', ':p') . 'gitman'
        let g:cmdbyu_dockerCommand
            \ = 'docker run --rm -it {volume}'
            \ . ' --network host local/mizarch {shCmd}'

        nmap <CR>us      :CmdByURun syntax
        nmap <CR>usg     :CmdByURun syntax global
        nmap <CR>Us  :CmdByUHostRun syntax
        nmap <CR>Usg :CmdByUHostRun syntax global
        nmap <CR>ur      :CmdByURun syntaxRun
        nmap <CR>urg     :CmdByURun syntaxRun global
        nmap <CR>Ur  :CmdByUHostRun syntaxRun
        nmap <CR>Urg :CmdByUHostRun syntaxRun global
        nmap <CR>ud      :CmdByURun syntaxDev
        nmap <CR>udg     :CmdByURun syntaxDev global
        nmap <CR>Ud  :CmdByUHostRun syntaxDev
        nmap <CR>Udg :CmdByUHostRun syntaxDev global


    " >> 基礎設置 -------

        filetype plugin on
        set fileformat=unix
        set enc=utf8
        syntax on

        " 滑鼠功能只在 Visual 模式下使用
        set mouse=v
        " 在 insert 模式啟用 backspace 鍵
        set backspace=2

        " 保留 99 個歷史指令
        set history=99

        " 顯示行號
        set number
        " 顯示相對行號
        set relativenumber

        " 使用 \t 的 Tab
        " set noexpandtab
        " 使用空白的 Tab
        set expandtab
        " 縮排 (Tab) 位元數
        set tabstop=4
        set shiftwidth=4
        " 依照檔案類型自動決定縮排樣式
        " filetype indent on

        " 設定縮排寬度

            nmap <CR>tab  :BwaySetIndentTabWidth
            nmap <CR>tab2 :BwaySetIndentTabWidth 2<CR>
            nmap <CR>tab4 :BwaySetIndentTabWidth 4<CR>
            nmap <CR>tab8 :BwaySetIndentTabWidth 8<CR>

        " 高亮游標行 (水平)
        set cursorline
        " 高亮游標行列 (垂直)
        set cursorcolumn

        " 顯示右下角的 行,列 目前在文件的位置 % 的資訊
        set ruler


    " >> 會話紀錄 -------

        " TODO
        echom '.vimrc 會話紀錄'

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


    " >> 風格配置 -------

        " 啟用暗色背景模式
        set background=dark

        " 設定行號為：粗體，前景色為深灰色，沒有背景色
        hi LineNr cterm=bold ctermfg=DarkGrey ctermbg=NONE


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

        " 自動縮排
        set ai

            nmap <CR>pas :set paste<CR>
            nmap <CR>pno :set nopaste<CR>

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

        " 自動補齊
        " (keyword: omnifunc)
        " <C-x><C-o> 為預設的補齊按键组合
        imap <C-m> <C-x><C-o>

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


    " >> 常用命令提示 -------

        function! ZCommandHelp()
            echo "常用命令提示\n=======\n\n"
            echo '> @: 為 Enter 鍵 (<CR>)'

            echo ' '
            echo '基礎：'
            echo '    @H : 幫助       @rvc : 更新 .vimrc'
            echo '    @s : 儲存文件   @q : 退出文件'

            echo ' '
            echo '會話紀錄：'
            echo '    @rss,  @rsr,  @rsd  : 保存、恢復、刪除自定義名稱的會話'
            echo '    @rssc, @rsrc, @rsdc : 保存、恢復、刪除名為 Cupcake 的會話'
            echo '    @rssd, @rsrd, @rsdd : 保存、恢復、刪除名為 Donut 的會話'
            echo '    @rsse, @rsre, @rsde : 保存、恢復、刪除名為 Eclair 的會話'

            echo ' '
            echo '插件管理：'
            echo '    @rpi : 安裝未安裝的插件   @rpu : 安裝或更新插件   @rpc : 移除未使用的插件目錄'
            echo ' '
            echo '    程式碼檢查：'
            echo '        @rfs : 刪除多餘空白'
            echo ' '
            echo '    命令行著色：'
            echo '        @rcc : 預設/著色切換'
            echo ' '
            echo '    查找文件：'
            echo '        Ff : 開啟指定路徑文件  Fb : 開啟指定緩衝區文件'
            echo ' '
            echo '    程式碼目錄：'
            echo '        <F8> : 開啟/關閉'
            echo ' '
            echo '    標記減量預覽：'
            echo '        @rmd : 預覽標記減量    @rmdstop : 關閉預覽標記減量'
            echo ' '
            echo '    Go 程式語言：'
            echo '        @gof (@gofmt) : 格式化'
            echo '        @gor (@gorun) : 運行'
            echo ' '
            echo '    命令由你：'
            echo '        > <u|U> 小寫表示以容器運行； 反之以主機運行'
            echo '        > [g]   可選。 表示執行全域的執行文件'
            echo '        @<u|U>s[g] : syntax'
            echo '        @<u|U>r[g] : run       @<u|U>d[g] : dev'

            echo ' '
            echo '緩衝區：'
            echo '    @bl : 緩衝區列表'
            echo '    @bm : 前一個開啟的緩衝區'
            echo '    @bk : 上一個緩衝區         @bj : 下一個緩衝區'
            echo '    @bd : 解除安裝緩衝區'

            echo ' '
            echo '搜尋文件內容：'
            echo '    @sr  : 使用 `grep -rin <正規語法> <起始路徑>'
            echo '    @cp  : 上一個搜尋位置      @cn  : 下一個搜尋位置'
            echo '    @cfp : 上一個文件位置      @cfn : 下一個文件位置'
            echo '    @clo : 開啟清單列          @clc : 關閉清單列'
            echo '    @clp : 上一個清單列        @cln : 下一個清單列'

            echo ' '
            echo '視窗：'
            echo '    <C-w> s : 切割水平視窗     <C-w> v : 切割垂直視窗'
            echo ' '
            echo '    @ww   : 順序地切換視窗'
            echo '    @wh   : 移動至左側的視窗   @wl   : 移動至右側的視窗'
            echo '    @wj   : 移動至下方的視窗   @wk   : 移動至上方的視窗'
            echo ' '
            echo '    @wrh  : 加高視窗 + [Num]   @wrH  : 縮高視窗 + [Num]'
            echo '    @wrw  : 加寬視窗 + [Num]   @wrW  : 縮寬視窗 + [Num]'
            echo ' '
            echo '    @wtl  : 分頁列表           @wte  : 新增分頁'
            echo '    @wtp  : 上一分頁           @wtn  : 下一分頁'
            echo ' '
            echo '    <C-z> : 背景工作'

            echo ' '
            echo '縮排：'
            echo '    @tab  : 設定縮排寬度 ( @tab2、@tab4、@tab8 )'
            echo '    @pas  : 貼上模式            @pno : 取消貼上模式'
            echo '    @side : 啟用/關閉側邊欄'

            echo ' '
            echo '摺疊方式：'
            echo '    @fmi : 依 shiftwidth 的縮排方式摺疊   @fmm : 手動摺疊'
            echo '    zn    : 禁用折疊                       zN    : 啟用折疊'
            echo '    za    : 打開或關閉當前的折疊'
            echo '    zo    : 打開當前的折疊                 zc    : 關閉當前打開的折疊'
            echo '    zr    : 打開所有折疊                   zm    : 關閉所有折疊'
            echo '    zR    : 打開所有折疊及其嵌套的折疊     zM    : 關閉所有折疊及其嵌套的折疊'
            echo '    zj    : 移動至下一個折疊               zk    : 移動至上一個折疊'
            echo ' '
            echo '    手動摺疊命令：'
            echo '        zf[Num](jk)     : 加上數字與方向指定摺疊範圍'
            echo '        zfa(<>, {}, ()) : 指定項目的摺疊'
            echo '        zd : 移除所在位置的摺疊'

            echo ' '
            echo '鍵盤行為紀錄區：'
            echo '    q          : 停止紀錄'
            echo '    q<\w>      : 開始記錄並儲存於 <\w> 記錄區'
            echo '    [Num]@<\w> : 重演 <\w> 記錄區'

            echo ' '
            echo '額外功能：'
            echo '    @dir : 對當前文件目錄操作'
            echo ' '
            echo '    Kiang：'
            echo '        VimGameCodeBreak : 打程式碼方塊'

            echo ' '
        endfunction

        command! BwayZCommandHelp :call ZCommandHelp()
        nmap <CR>H :BwayZCommandHelp<CR>


" 初始化插件系統
call plug#end()

