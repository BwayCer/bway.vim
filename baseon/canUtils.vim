" 罐頭工具

" 若依賴本文件，請將本文件複製至 `~/.vim/autoload/canUtils.vim`。


" 在 source 載入期間取得當前文件所在的目錄的方法
" let s:_dirvi = fnamemodify(resolve(expand('<sfile>:p')), ':h')


" 載入文件
function! canUtils#ImportFile(originPath, findExpr, execExpr)
  let l:findFile = globpath(a:originPath, a:findExpr)
  let l:fileList = filter(split(l:findFile, '\n'), '!isdirectory(v:val)')

  for l:filePath in l:fileList
    exec a:execExpr . l:filePath
  endfor
endfunction

" 載入 vim 文件
function! canUtils#ImportVim(pluginPath, ...)
  let l:expr = get(a:, 1, '*.vim')
  call canUtils#ImportFile(a:pluginPath, l:expr, 'source ')
endfunction

" 載入 python 文件
"   載入後調用 python 函式的方法:
"   ```py
"   def fn():
"       return 'hi'
"   ```
"   ```vim
"   let rtn = py3eval('fn()')
"   echo rtn
"   ```
function! canUtils#ImportPython(pyLibPath, ...)
  let l:expr = get(a:, 1, '*.py')
  call canUtils#ImportFile(a:pyLibPath, l:expr, 'py3file ')
endfunction


" 以反斜線編碼文字中的引號
function! canUtils#SafeQuote(txt)
  let l:symbolList = ['\', '"', '`']
  let l:expr = a:txt
  for l:pat in l:symbolList
    let l:expr = substitute(l:expr, l:pat, '\\\' . l:pat, 'g')
  endfor
  return l:expr
endfunction

" 可共用的取得命令行命令文字
function! s:getCmdTxt(cmdList)
  let l:separator = ''
  let l:cmdTxt = ''
  for l:argu in a:cmdList
    let l:cmdTxt .= l:separator
    if l:argu =~# '^%:'
      let l:cmdTxt .= substitute(l:argu, '%:', '', '')
    else
      let l:cmdTxt .= '"' . canUtils#SafeQuote(l:argu) . '"'
    endif
    let l:separator = ' '
  endfor
  return l:cmdTxt
endfunction

" 取得命令行命令文字
function! canUtils#GetCmdTxt(...)
  return s:getCmdTxt(a:000)
endfunction

" 運行命令行命令
function! canUtils#Sh(...)
  " TODO: DEBUG:
  echom s:getCmdTxt(a:000)
  return system(s:getCmdTxt(a:000))
endfunction

" 運行命令行命令並整理回傳訊息
function! canUtils#ShMiddle(...)
  let l:result = system(s:getCmdTxt(a:000))
  let l:info = {'errCode': v:shell_error, 'result': l:result}
  let l:info.lineList = split(l:result, '\n')
  return l:info
endfunction

