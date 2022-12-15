
" 請務必使用單引號

" >> 定位 .vimrc 文件 -------
  " Neovim 沒有 vim 般去規範文件位置並自動載入，
  " 只知道有三個慣用位置為：
  "   - $HOME/.config/nvim/init.vim
  "   - $HOME/.local/share/site/autoload/plug.vim
  "   - $HOME/.local/share/plugged
  " 但其中只有第一個會自動載入。


  let g:vimrc = resolve(fnamemodify(expand("$MYVIMRC"), ":p"))
  let g:vimDir = fnamemodify(g:vimrc, ":h")

    nmap <silent> <CR>rvc :execute 'source ' . g:vimrc<CR>


" >> base style -------

  " 取消向下支援
  set nocompatible
  set t_Co=256

  execute 'source ' . g:vimDir . '/baseon/canUtils.vim'
  call canUtils#ImportVim(g:vimDir . '/baseon/bway')
  " call canUtils#ImportPython(g:vimDir . '/baseon/bway')
  execute 'source ' . g:vimDir . '/baseon/bway.vim'

  if has('nvim')
    execute 'source ' . g:vimDir . '/baseon/bwayNeo.vim'
  endif


" >> vim-plug 管理器 -------

  if !empty(g:vimDir . '/localShare/site/autoload/plug.vim')
    execute 'source ' . g:vimDir . '/localShare/site/autoload/plug.vim'

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
    call plug#begin(g:vimDir . '/localShare/plugged')

      execute 'source ' . g:vimDir . '/baseon/plug.vim'

      if has('nvim')
        execute 'source ' . g:vimDir . '/baseon/plugNeo.vim'
        execute 'source ' . g:vimDir . '/baseon/plug-coc.vim'
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
    echo '主程式包： (BwayCer/bway.vim)'
    echo ' '
    echo '    會話紀錄：'
    echo '        @rss,  @rsr,  @rsd  : 保存、恢復、刪除主要會話'
    echo '        @rssc, @rsrc, @rsdc : 保存、恢復、刪除名為 Cupcake 的會話'
    echo '        @rssd, @rsrd, @rsdd : 保存、恢復、刪除名為 Donut 的會話'
    echo '        @rsse, @rsre, @rsde : 保存、恢復、刪除名為 Eclair 的會話'
    echo ' '
    echo '    編輯小工具：'
    echo '        @rfs : 刪除多餘空白'
    echo ' '
    echo '        > 選取模式'
    echo '        @?   : 註解選取行      @/   : 反註解選取行'

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

