
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

" Go 程式語言
Plug 'fatih/vim-go'

  nmap <CR>gof   :GoFmt<CR>
  nmap <CR>gofmt :GoFmt<CR>
  nmap <CR>gor   :GoRun<CR>
  nmap <CR>gorun :GoRun<CR>

" Go 程式語言 - 語法提示
Plug 'nsf/gocode', { 'rtp': 'vim', 'do': '~/.vim/plugged/gocode/vim/symlink.sh' }

" Dart 程式語言 - 螢光筆、語法檢查、格式化
Plug 'dart-lang/dart-vim-plugin'

" Pug 程式語言 - 螢光筆
Plug 'digitaltoad/vim-pug'

" Solidity 程式語言 - 螢光筆
Plug 'tomlion/vim-solidity'

" kiang: 打程式碼方塊
Plug 'johngrib/vim-game-code-break'

  command! KiangVimGameCodeBreak :call VimGameCodeBreak#game#main()

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

