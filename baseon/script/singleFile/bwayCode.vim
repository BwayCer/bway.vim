
" >> 執行工具 -------

  let s:codeDiagnosticInfo = {
        \ 'javascript.diagnostic': 'eslint.run',
        \ 'javascript.run': 'node'}

  function! bwayCode#Diagnostic()
    let infoKey = &filetype . '.diagnostic'
    if !has_key(s:codeDiagnosticInfo, infoKey)
      echo '沒有 ' . &filetype . ' 文件類型的程式碼診斷'
      return
    elseif !executable(s:codeDiagnosticInfo[infoKey])
      echo '找不到 ' . s:codeDiagnosticInfo[infoKey] . ' 命令'
      return
    endif

    let currFilePath = expand('%:p')
    let chanBufContentPath = '/tmp/nvim-bwayCode-chanBufferContent'
    let chanSyntaxPath = '/tmp/nvim-bwayCode-chanSyntax'

    " call system('find /tmp -type f -name nvim-bwayCode_*')
    exec 'write! ' . chanBufContentPath

    if &filetype == 'javascript'
      call s:bwayCode_diagnostic_eslint(
            \ currFilePath, chanBufContentPath, chanSyntaxPath)
    endif

    if getfsize(chanSyntaxPath) > 0
      let currFileName = expand('%')
      let &errorformat
          \ = '%f:%l:%c:%t:%m'
          \ . ',%f:%l:%c::%m'
      let &makeprg = 'cat ' . chanSyntaxPath
      make
      copen
      let w:quickfix_title = 'Code diagnostic for ' . currFileName
    else
      echo '通過程式碼診斷 ok'
      cclose
    endif
  endfunction


  let s:codeRunAllowList = [
        \ 'javascript']

  function! bwayCode#Run()
    let infoKey = &filetype . '.run'
    if !has_key(s:codeDiagnosticInfo, infoKey)
      echo '沒有 ' . &filetype . ' 文件類型的運行工具'
      return
    elseif !executable(s:codeDiagnosticInfo[infoKey])
      echo '找不到 ' . s:codeDiagnosticInfo[infoKey] . ' 命令'
      return
    endif

    let currFilePath = expand('%:p')

    if &filetype == 'javascript'
      echo system('node "' . currFilePath . '"')
    endif
  endfunction


" >> node eslint -------

  function! s:bwayCode_diagnostic_eslint(filePath, chanBufContentPath, chanSyntaxPath)
    let pattern =
          \ '^.*: line \([0-9]\+\), col \([0-9]\+\),'
          \ . ' \(E\|W\)\(rror\|arning\) - \(.\+\)'
    let cmdTxt =
          \ 'eslint.run --format compact "' . a:chanBufContentPath . '"'
          \ . ' | grep "' . pattern . '"'
          \ . ' | sed "s/' . pattern . '/\1:\2:\3:\5/"'
          \ . ' | awk "{print \"' . a:filePath . ':\"\$0}"'
          \ . ' > "' . a:chanSyntaxPath . '"'
    echo system(cmdTxt)
  endfunction

