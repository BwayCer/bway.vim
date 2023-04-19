
" 中文說明文件
Plug 'chusiang/vimcdoc-tw'

" 翻譯器
Plug 'voldikss/vim-translator'

  " engines 的中文支持有 google, haici
  let g:translator_default_engines = ['google']
  let g:translator_target_lang = 'zh-TW' " en, ja
  let g:translator_source_lang = 'auto'

  " nmap <CR>TTzh :Translate --engines=google --target_lang=zh-TW<CR>
  " 在命令行中顯示翻譯
  nmap <silent> <CR>TT <Plug>Translate
  " 在浮動框中顯示翻譯
  nmap <silent> <CR>TW <Plug>TranslateW
  " 用翻譯替換文本
  nmap <silent> <CR>TR <Plug>TranslateR
  " 翻譯剪貼板中的文本
  nmap <silent> <CR>TX <Plug>TranslateX

  " en
  nmap <CR>TTen :Translate  --target_lang=en<CR>
  nmap <CR>TWen :TranslateW --target_lang=en<CR>
  nmap <CR>TRen :TranslateW --target_lang=en<CR>
  nmap <CR>TXen :TranslateW --target_lang=en<CR>
  " ja
  nmap <CR>TTja :Translate  --target_lang=ja<CR>
  nmap <CR>TWja :TranslateW --target_lang=ja<CR>
  nmap <CR>TRja :TranslateW --target_lang=ja<CR>
  nmap <CR>TXja :TranslateW --target_lang=ja<CR>

" Vim 腳本的函式庫
Plug 'vim-scripts/L9'
  " export for 'vim-scripts/FuzzyFinder'

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

