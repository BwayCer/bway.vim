
" >> -------

  " 從 Vim 遷移至 Neovim：
  "   * ~/.vimrc         -> ~/.config/nvim/init.vim
  "   * ~/.vim/autoload/ -> ~/.local/share/nvim/site/autoload/
  "
  " 本專案結構：┌┬┐└┴┘├┼┤─
  "   * link:
  "     * ./entry.vim         -> ~/.vimrc
  "     * ./space/config/     -> ~/.config/nvim/
  "     * ./space/local/site/ -> ~/.local/share/nvim/site/
  "   * ./entry.vim [自動載入]  ---------- 入口文件
  "   * ./baseon/*/base.vim  ----- 基本編輯器功能
  "   * ./baseon/*/script/*/*  --- 我的類程式包腳本
  "   * ./baseon/*/plug.vim  ----- 通用程式包
  "   * Plug:
  "     * ./space/local/site/autoload/plug.vim [自動載入]
  "     * ./space/local/site/plugged/ ------------ plug.vim 程式包存放處

  " 請務必使用單引號

  " Q:你們的vim配置都換成lua了嗎？ A:年輕人不要激動
  "   https://www.zhihu.com/question/445290918
  " ```
  " if has('nvim')
  "   exec 'luafile ' . g:vimDir . '/lua/plugins.lua'
  "   exec 'luafile ' . g:vimDir . '/lua/plug.lua'
  "   lua require('plugins')
  "   lua require('plug')
  " endif
  " ```


" >> 定位 .vimrc 文件 -------

  let s:vimrc = fnamemodify(resolve(expand('$MYVIMRC')), ':p')
  let g:vimDir = fnamemodify(s:vimrc, ':h')

    exec ":nmap <CR>rvc :echo 'source " . s:vimrc . "'"
          \ . " \\| :silent source " . s:vimrc . '<CR>'


  " 辨別編輯器
  let s:vimEditor = has('nvim') ? 'neo' : 'vim'


" >> base style -------

  " 取消向下支援
  set nocompatible
  set t_Co=256


  " 基本編輯器功能
  execute 'source ' . g:vimDir . '/baseon/base.vim'

  if filereadable(g:vimDir . '/baseon/' . s:vimEditor . '/base.vim')
    exec 'source ' . g:vimDir . '/baseon/' . s:vimEditor . '/base.vim'
  endif


  " 我的類程式包腳本
  exec 'source ' . g:vimDir . '/baseon/canUtils.vim'
  call canUtils#ImportVim(g:vimDir . '/baseon/script', '*/*.vim')
  exec 'source ' . g:vimDir . '/baseon/scriptPlug.vim'

  if filereadable(g:vimDir . '/baseon/' . s:vimEditor . '/scriptPlug.vim')
    call canUtils#ImportVim(
          \   g:vimDir . '/baseon/' . s:vimEditor . '/script',
          \   '*/*.vim'
          \ )
    exec 'source ' . g:vimDir . '/baseon/' . s:vimEditor . '/scriptPlug.vim'
  endif


" >> vim-plug 管理器 -------

  if filereadable(g:vimDir . '/space/local/site/autoload/plug.vim')
    exec 'source ' . g:vimDir . '/space/local/site/autoload/plug.vim'

      nmap <CR>rvpi :PlugInstall<CR>
      nmap <CR>rvpu :PlugUpdate<CR>
      nmap <CR>rvpc :PlugClean<CR>
      " :PlugUpgrade   - 更新 vim-plug 管理器
      " :PlugInstall   - 安裝未安裝的插件
      " :PlugUpdate    - 安裝或更新插件
      " :PlugClean     - 移除未使用的插件目錄
      " :PlugStatus    - 查看目前插件狀態

    " 指定放置插件的目錄
    " - 避免去使用 Vim 的規範目錄名稱， 如：`plugin`
    call plug#begin(g:vimDir . '/space/local/site/plugged')

      exec 'source ' . g:vimDir . '/baseon/plug.vim'

      if filereadable(g:vimDir . '/baseon/' . s:vimEditor . '/plug.vim')
        exec 'source ' . g:vimDir . '/baseon/' . s:vimEditor . '/plug.vim'
      endif

    " 初始化插件系統
    call plug#end()
  endif


" >> 常用命令提示 -------

  function! ZCommandHelp()
    echo "常用命令提示\n=======\n\n"
    echo '> @: 為 Enter 鍵 (<CR>)'

    echo ' '
    echo '基礎：'
    echo '    @H : 幫助       @rvc : 更新 .vimrc'
    echo '    @s : 儲存文件   @q : 退出文件'
    echo ' '
    echo '    @dir : 對當前文件目錄操作'
    echo '        快捷鍵見 <F1> or :h netrw-browse-maps'
    echo '        - -/d/%/R/D  回上層/新目錄/新文件/更名/刪除'
    echo '        - p/v/<cr> 預覽/在左側分割視窗開啟/當前視窗開啟'
    echo '        - u/U     切換到較早/較晚訪問的目錄'

    echo ' '
    echo '我的腳本：'
    echo ' '
    echo '    編輯小工具：'
    echo '        @rfs : 刪除多餘空白'
    echo ' '
    echo '    縮排：'
    echo '        @tab  : 設定縮排寬度 ( @tab2、@tab4、@tab8 )'
    echo '        @pas  : 貼上模式            @pno : 取消貼上模式'
    echo '        @side : 啟用/關閉側邊欄'
    echo ' '
    echo '    註解： (> 選取模式)'
    echo '        @?   : 註解選取行      @/   : 反註解選取行'
    echo ' '
    echo '    會話紀錄：'
    echo '        @rsp  : 問答式選擇保存、恢復、刪除會話'
    echo '        @rsp<c|d|e|f> : Cupcake, Donut, Eclair, Froyo 的問答式會話操作'

    echo ' '
    echo '程式包管理：'
    echo '    @rvpi : 安裝未安裝的插件   @rvpc : 移除未使用的插件目錄'
    echo '    @rvpu : 安裝或更新插件'
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
    echo '    Neo: 標記減量預覽：'
    echo '        @rmd : 預覽標記減量    @rmdstop : 關閉預覽標記減量'

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
    echo '插入模式自動補全：'
    echo '      :h ins-completion'
    " echo '    imap <C-n>       : 基本的關鍵字補全'
    echo '    imap <C-x><C-f>  : 檔名'
    echo '    imap <C-x><C-l>  : 整行'
    echo '    imap <C-x><C-n>  : 當前檔案內的關鍵字'
    echo '    imap <C-x><C-i>  : 當前和標頭檔案內的關鍵字'
    echo '    imap <C-x><C-v>  : Vim 命令'
    " echo '    imap <C-x><C-d>  : 定義或宏'
    " echo '    imap <C-x><C-]>  : 標籤'
    " echo '    imap <C-x><C-k>  : "dictionary" 的關鍵字'
    " echo '    imap <C-x><C-t>  : "thesaurus" 的關鍵字，同義詞風格'
    " echo '    imap <C-x><C-u>  : 使用者定義的補全'
    " echo '    imap <C-x><C-o>  : 全能 (omni) 補全'
    " echo '      <C-x><C-o> 為預設的補齊按键组合 (keyword: omnifunc)'
    " echo '    imap <C-x><C-s>  : 拼寫建議'

    echo ' '
    echo '額外功能：'
    echo '    Kiang：'
    echo '        VimGameCodeBreak : 打程式碼方塊'

    echo ' '
  endfunction

  nmap <CR>H :call ZCommandHelp()<CR>

