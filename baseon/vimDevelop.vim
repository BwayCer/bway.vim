" vim 開發中...


" >> 保留紀錄 -------

  " function! TmpZCommandHelp(argLead, cmdLine, cursorPos)
    " return system('echo ' . a:argLead . ', ' .  a:cmdLine . ', ' . a:cursorPos . ' > ~/.vim/hi.txt')
    " return 'js'
  " endfunction

  " command! -complete=custom,TmpZCommandHelp -nargs=* BwayZCommandHelp :call ZCommandHelp(<f-args>)


" >> vim 的命令補全 -------

  " h :command-complete


