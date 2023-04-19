
" Coc 是繼 plug 後另外一個外掛，所以額外提出來單獨寫

" 2022.12.15
"   目前在 vim 使用 Coc 會遇到一個問題，
"   當該分頁有兩格以上視窗且自動補完提示框跳出時，
"   光標會切換到該分頁下某個固定的文件上。

" 主機語言服務器 和 Nodejs 擴展工具
Plug 'neoclide/coc.nvim', {'branch': 'release'}

  " >> CocConfig -------

    " // 停用自動補完，不會自動跳出提示窗
    " "suggest.autoTrigger": "none",
    " // 停用自動選擇自動補完的第一選項
    " // (其功能即便選擇了也無法直接使用，仍需再按 ctrl-v，
    " // 若按下慣用的 ctrl-n 則會變成選擇第二選項。)
    " "suggest.noselect": true,


  " >>  -------

    " 執行語言服務器需有對應的命令 (ex: coc-flutter 需安裝 flutter)，否則會出現訊息:
    "   Error on notification "doHover": hover provider not found for current
    "   buffer, your language server don't support it.
    let g:coc_global_extensions = [
          \   'coc-flutter',
          \ ]

    let s:cocEnableFiletype = [
          \   'dart',
          \ ]

    function! s:show_documentation()
      if (index(['vim','help'], &filetype) >= 0)
        exec 'h '.expand('<cword>')
      elseif (index(s:cocEnableFiletype, &filetype) >= 0)
        " call CocAction('doHover')
        call CocActionAsync('doHover')
      endif
    endfunction

    nnoremap <silent> K :call <SID>show_documentation()<CR>

    " Remap <C-f> and <C-b> for scroll float windows/popups.
    if has('nvim-0.4.0') || has('patch-8.2.0750')
      nmap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
      nmap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
      imap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
      imap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
      vmap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
      vmap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    endif

    " 如果同一分頁有兩個文件視窗，
    " 自動補完只能作用於同一文件視窗。
    function! CocAutoCompleteSwitch()
      if (index(s:cocEnableFiletype, &filetype) >= 0)
        let b:coc_suggest_disable = 0
      else
        let b:coc_suggest_disable = 1
      endif
    endfunction

    " autocmd BufEnter * :call CocAutoCompleteSwitch()

    " 導航至診斷位置
    nmap <silent> <CR>cg[ <Plug>(coc-diagnostic-prev)
    nmap <silent> <CR>cg] <Plug>(coc-diagnostic-next)

    " 導航至代碼位置
    nmap <silent> <CR>cgd <Plug>(coc-definition)
    nmap <silent> <CR>cgy <Plug>(coc-type-definition [類型定義] )
    nmap <silent> <CR>cgi <Plug>(coc-implementation [履行] )
    nmap <silent> <CR>cgr <Plug>(coc-references)


  " >> 字體顏色 -------
    " Neovim 預設的顏色暗色主題有衝突，所以將 vim 的預設格式複製貼上。

    hi CocMenuSel     ctermbg=238 guibg=#494949
    hi CocListLine    ctermbg=236 guibg=#383838
    hi CocSelectedText ctermfg=9 guifg=#fb4934
    hi CocCodeLens    ctermfg=248 guifg=#999999
    hi CocUnderline   term=underline cterm=underline gui=underline guisp=#ebdbb2
    hi CocBold        term=bold cterm=bold gui=bold
    hi CocItalic      term=italic cterm=italic gui=italic
    hi CocStrikeThrough term=strikethrough cterm=strikethrough gui=strikethrough
    hi CocMarkdownLink ctermfg=12 guifg=#15aabf
    hi CocDisabled    ctermfg=248 guifg=#999999
    hi CocSearch      ctermfg=12 guifg=#15aabf
    hi CocLink        term=underline cterm=underline gui=underline guisp=#15aabf
    hi CocFloating    ctermbg=237 guibg=#414141
    hi CocFloatThumb  ctermbg=239 guibg=#585858
    hi CocNotificationProgress ctermfg=12 guifg=#15aabf
    hi CocErrorFloat  ctermfg=9 ctermbg=237 guifg=#ff0000 guibg=#414141
    hi CocWarningFloat ctermfg=130 ctermbg=237 guifg=#ff922b guibg=#414141
    hi CocInfoFloat   ctermfg=11 ctermbg=237 guifg=#fab005 guibg=#414141
    hi CocVirtualText ctermfg=12 guifg=#504945
    hi CocErrorSign   ctermfg=9 guifg=#ff0000
    hi CocErrorVirtualText ctermfg=9 guifg=#ff0000
    hi CocWarningSign ctermfg=130 guifg=#ff922b
    hi CocWarningVirtualText ctermfg=130 guifg=#ff922b
    hi CocInfoSign    ctermfg=11 guifg=#fab005
    hi CocInfoVirtualText ctermfg=11 guifg=#fab005
    hi CocHintSign    ctermfg=12 guifg=#15aabf
    hi CocHintVirtualText ctermfg=12 guifg=#15aabf
    hi CocHintFloat   ctermfg=12 ctermbg=237 guifg=#15aabf guibg=#414141
    hi CocInlayHint   ctermfg=12 ctermbg=242 guifg=#15aabf guibg=Grey
    hi CocListBlackBlack guifg=#282828 guibg=#282828
    hi CocListBlackBlue guifg=#282828 guibg=#458588
    hi CocListBlackGreen guifg=#282828 guibg=#98971a
    hi CocListBlackGrey guifg=#282828 guibg=#928374
    hi CocListBlackWhite guifg=#282828 guibg=#a89984
    hi CocListBlackCyan guifg=#282828 guibg=#689d6a
    hi CocListBlackYellow guifg=#282828 guibg=#d79921
    hi CocListBlackMagenta guifg=#282828 guibg=#b16286
    hi CocListBlackRed guifg=#282828 guibg=#cc241d
    hi CocListFgBlack ctermfg=0 guifg=#282828
    hi CocListBgBlack ctermbg=0 guibg=#282828
    hi CocListBlueBlack guifg=#458588 guibg=#282828
    hi CocListBlueBlue guifg=#458588 guibg=#458588
    hi CocListBlueGreen guifg=#458588 guibg=#98971a
    hi CocListBlueGrey guifg=#458588 guibg=#928374
    hi CocListBlueWhite guifg=#458588 guibg=#a89984
    hi CocListBlueCyan guifg=#458588 guibg=#689d6a
    hi CocListBlueYellow guifg=#458588 guibg=#d79921
    hi CocListBlueMagenta guifg=#458588 guibg=#b16286
    hi CocListBlueRed guifg=#458588 guibg=#cc241d
    hi CocListFgBlue  ctermfg=12 guifg=#458588
    hi CocListBgBlue  ctermbg=12 guibg=#458588
    hi CocListGreenBlack guifg=#98971a guibg=#282828
    hi CocListGreenBlue guifg=#98971a guibg=#458588
    hi CocListGreenGreen guifg=#98971a guibg=#98971a
    hi CocListGreenGrey guifg=#98971a guibg=#928374
    hi CocListGreenWhite guifg=#98971a guibg=#a89984
    hi CocListGreenCyan guifg=#98971a guibg=#689d6a
    hi CocListGreenYellow guifg=#98971a guibg=#d79921
    hi CocListGreenMagenta guifg=#98971a guibg=#b16286
    hi CocListGreenRed guifg=#98971a guibg=#cc241d
    hi CocListFgGreen ctermfg=10 guifg=#98971a
    hi CocListBgGreen ctermbg=10 guibg=#98971a
    hi CocListGreyBlack guifg=#928374 guibg=#282828
    hi CocListGreyBlue guifg=#928374 guibg=#458588
    hi CocListGreyGreen guifg=#928374 guibg=#98971a
    hi CocListGreyGrey guifg=#928374 guibg=#928374
    hi CocListGreyWhite guifg=#928374 guibg=#a89984
    hi CocListGreyCyan guifg=#928374 guibg=#689d6a
    hi CocListGreyYellow guifg=#928374 guibg=#d79921
    hi CocListGreyMagenta guifg=#928374 guibg=#b16286
    hi CocListGreyRed guifg=#928374 guibg=#cc241d
    hi CocListFgGrey  ctermfg=248 guifg=#928374
    hi CocListBgGrey  ctermbg=248 guibg=#928374
    hi CocListWhiteBlack guifg=#a89984 guibg=#282828
    hi CocListWhiteBlue guifg=#a89984 guibg=#458588
    hi CocListWhiteGreen guifg=#a89984 guibg=#98971a
    hi CocListWhiteGrey guifg=#a89984 guibg=#928374
    hi CocListWhiteWhite guifg=#a89984 guibg=#a89984
    hi CocListWhiteCyan guifg=#a89984 guibg=#689d6a
    hi CocListWhiteYellow guifg=#a89984 guibg=#d79921
    hi CocListWhiteMagenta guifg=#a89984 guibg=#b16286
    hi CocListWhiteRed guifg=#a89984 guibg=#cc241d
    hi CocListFgWhite ctermfg=15 guifg=#a89984
    hi CocListBgWhite ctermbg=15 guibg=#a89984
    hi CocListCyanBlack guifg=#689d6a guibg=#282828
    hi CocListCyanBlue guifg=#689d6a guibg=#458588
    hi CocListCyanGreen guifg=#689d6a guibg=#98971a
    hi CocListCyanGrey guifg=#689d6a guibg=#928374
    hi CocListCyanWhite guifg=#689d6a guibg=#a89984
    hi CocListCyanCyan guifg=#689d6a guibg=#689d6a
    hi CocListCyanYellow guifg=#689d6a guibg=#d79921
    hi CocListCyanMagenta guifg=#689d6a guibg=#b16286
    hi CocListCyanRed guifg=#689d6a guibg=#cc241d
    hi CocListFgCyan  ctermfg=14 guifg=#689d6a
    hi CocListBgCyan  ctermbg=14 guibg=#689d6a
    hi CocListYellowBlack guifg=#d79921 guibg=#282828
    hi CocListYellowBlue guifg=#d79921 guibg=#458588
    hi CocListYellowGreen guifg=#d79921 guibg=#98971a
    hi CocListYellowGrey guifg=#d79921 guibg=#928374
    hi CocListYellowWhite guifg=#d79921 guibg=#a89984
    hi CocListYellowCyan guifg=#d79921 guibg=#689d6a
    hi CocListYellowYellow guifg=#d79921 guibg=#d79921
    hi CocListYellowMagenta guifg=#d79921 guibg=#b16286
    hi CocListYellowRed guifg=#d79921 guibg=#cc241d
    hi CocListFgYellow ctermfg=11 guifg=#d79921
    hi CocListBgYellow ctermbg=11 guibg=#d79921
    hi CocListMagentaBlack guifg=#b16286 guibg=#282828
    hi CocListMagentaBlue guifg=#b16286 guibg=#458588
    hi CocListMagentaGreen guifg=#b16286 guibg=#98971a
    hi CocListMagentaGrey guifg=#b16286 guibg=#928374
    hi CocListMagentaWhite guifg=#b16286 guibg=#a89984
    hi CocListMagentaCyan guifg=#b16286 guibg=#689d6a
    hi CocListMagentaYellow guifg=#b16286 guibg=#d79921
    hi CocListMagentaMagenta guifg=#b16286 guibg=#b16286
    hi CocListMagentaRed guifg=#b16286 guibg=#cc241d
    hi CocListFgMagenta ctermfg=13 guifg=#b16286
    hi CocListBgMagenta ctermbg=13 guibg=#b16286
    hi CocListRedBlack guifg=#cc241d guibg=#282828
    hi CocListRedBlue guifg=#cc241d guibg=#458588
    hi CocListRedGreen guifg=#cc241d guibg=#98971a
    hi CocListRedGrey guifg=#cc241d guibg=#928374
    hi CocListRedWhite guifg=#cc241d guibg=#a89984
    hi CocListRedCyan guifg=#cc241d guibg=#689d6a
    hi CocListRedYellow guifg=#cc241d guibg=#d79921
    hi CocListRedMagenta guifg=#cc241d guibg=#b16286
    hi CocListRedRed  guifg=#cc241d guibg=#cc241d
    hi CocListFgRed   ctermfg=9 guifg=#cc241d
    hi CocListBgRed   ctermbg=9 guibg=#cc241d
    hi CocSymbolUnit  ctermfg=121 guifg=SeaGreen
    hi CocSymbolNumber ctermfg=207 guifg=#ffa0a0
    hi CocSymbolFunction ctermfg=14 guifg=#40ffff
    hi CocSymbolKey   ctermfg=14 guifg=#40ffff
    hi CocSymbolKeyword ctermfg=11 guifg=#ffff60
    hi CocSymbolReference ctermfg=207 guifg=#ffa0a0
    hi CocSymbolFolder ctermfg=121 guifg=SeaGreen
    hi CocSymbolVariable ctermfg=224 guifg=Orange
    hi CocSymbolNull  ctermfg=121 guifg=#60ff60
    hi CocSymbolValue ctermfg=121 guifg=SeaGreen
    hi CocSymbolConstant ctermfg=207 guifg=#ffa0a0
    hi CocSymbolText  ctermfg=121 guifg=SeaGreen
    hi CocSymbolModule ctermfg=11 guifg=#ffff60
    hi CocSymbolPackage ctermfg=11 guifg=#ffff60
    hi CocSymbolClass ctermfg=224 guifg=Orange
    hi CocSymbolOperator ctermfg=11 guifg=#ffff60
    hi CocSymbolStruct ctermfg=11 guifg=#ffff60
    hi CocSymbolObject ctermfg=121 guifg=SeaGreen
    hi CocSymbolMethod ctermfg=14 guifg=#40ffff
    hi CocSymbolArray ctermfg=121 guifg=SeaGreen
    hi CocSymbolEnum  ctermfg=121 guifg=SeaGreen
    hi CocSymbolField ctermfg=14 guifg=#40ffff
    hi CocSymbolInterface ctermfg=121 guifg=SeaGreen
    hi CocSymbolProperty ctermfg=14 guifg=#40ffff
    hi CocSymbolColor ctermfg=207 guifg=#ffa0a0
    hi CocSymbolFile  ctermfg=11 guifg=#ffff60
    hi CocSymbolEvent ctermfg=207 guifg=#ffa0a0
    hi CocSymbolTypeParameter ctermfg=14 guifg=#40ffff
    hi CocSymbolConstructor ctermfg=224 guifg=Orange
    hi CocSymbolSnippet ctermfg=121 guifg=SeaGreen
    hi CocSymbolBoolean ctermfg=207 guifg=#ffa0a0
    hi CocSymbolNamespace ctermfg=81 guifg=#ff80ff
    hi CocSymbolString ctermfg=207 guifg=#ffa0a0
    hi CocSymbolEnumMember ctermfg=14 guifg=#40ffff

