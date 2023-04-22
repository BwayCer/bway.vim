
" AI 請求相關
let s:answerCount = 0
let s:aiRequestLock = v:false
let s:aiRequestId = -1
let s:aiWriteLine = -1
let s:previewFloatWinIndex = -1


" 基本資訊
let s:bufferIndex = -1
let s:previewBufferIndex = -1
let s:bufferName = 'AssistantAI'

" 給如 Bito 需要以文件路徑為輸入參數的命令使用
let s:questionFilePath = '/tmp/formVim_questionToAI.txt'
let s:codeFilePath = '/tmp/formVim_codeToAI'


" 處理問答詞相關
let s:regexChooseAi = '^v \(Bito\|ChatGPT\)$'
let s:promptSectionCache = []
let g:defaultPrompt = [
      \   'I want you to act as a software developer. I will provide some specific information or requirements, and it will be your job to come up with an architecture and code for developing secure app.',
      \   'Please write in zh-TW language.']


function! s:calcWindowSize(contentLines, maxWidth)
  let width = 33
  let height = len(a:contentLines)
  for line in a:contentLines
    if len(line) > a:maxWidth
      let width = a:maxWidth
      let height += len(line) / a:maxWidth
    elseif len(line) > width
      let width = len(line)
    endif
  endfor
  return [width, height]
endfunction

function! s:closeFloatWindow(floatWinIndex)
  " 關閉窗口
  call nvim_win_close(a:floatWinIndex, v:true)
endfunction

function s:setAiRequestLock(isLock)
  if a:isLock
    let s:aiRequestLock = v:true
    call nvim_buf_set_option(s:bufferIndex, 'modifiable', v:false)
  else
    let s:aiRequestLock = v:false
    call nvim_buf_set_option(s:bufferIndex, 'modifiable', v:true)
  endif
endfunction

function! s:aiCmd_onStdout(chanId, data, evtName)
  if s:aiRequestId == a:chanId
    let lastLine = nvim_buf_get_lines(
          \ s:bufferIndex, s:aiWriteLine - 1, s:aiWriteLine, v:true)
    let a:data[0] = lastLine[0] . a:data[0]
    call s:nvim_buf_set_lines(
          \ s:bufferIndex, s:aiWriteLine - 1, s:aiWriteLine, v:true,
          \ a:data)
    let s:aiWriteLine = nvim_buf_line_count(s:bufferIndex)
  endif
endfunction

function! s:aiCmd_onExit(chanId, exitCode, evtName)
  if s:aiRequestId == a:chanId
    call s:setAiRequestLock(v:false)
  else
    echoerr '異常存在兩個AI請求 (id:' . a:chanId . ',' . s:aiRequestId . ')'
  endif

  if a:exitCode
    echoerr 'AI request command failed. (exitCode:' . a:exitCode . ')'
  endif
endfunction

function! s:nvim_buf_set_lines(buffer, start, end, strict_indexing, replacement)
  call nvim_buf_set_option(a:buffer, 'modifiable', v:true)

  " nvim_buf_set_lines(bufnr, start, end, strict_indexing, replacement)
  "   start 起始行，行號以 0 開始計算
  "   end 結束行
  "   strict_indexing 是否不能負值表示行末
  "   replacement 要替换的文本
  call nvim_buf_set_lines(a:buffer,
        \ a:start,
        \ a:end,
        \ a:strict_indexing,
        \ a:replacement)

  call nvim_buf_set_option(a:buffer, 'modifiable', v:false)

  " 若顯示訊息的緩衝區不在當前分頁則以浮動視窗顯示訊息
  if index(tabpagebuflist(), s:bufferIndex) == -1
    let popupMessageBufferIndex = nvim_create_buf(0, 1)
    call nvim_buf_set_lines(
          \ popupMessageBufferIndex, 0, -1, v:false, a:replacement)

    let winSize = s:calcWindowSize(a:replacement, 79)
    let popupMessageFloatWinIndex = nvim_open_win(
          \ popupMessageBufferIndex, 0, {
          \ 'relative': 'editor',
          \ 'row': 0,
          \ 'col': 0,
          \ 'width': winSize[0],
          \ 'height': winSize[1],
          \ 'style': 'minimal',
          \ 'border': 'single'})

    call timer_start(1200, {
          \ -> function('s:closeFloatWindow', [popupMessageFloatWinIndex])() })
  endif
endfunction


function! assistantAI#StatusInfo()
  if s:aiRequestLock
    return ' (AI 回答中...)'
  else
    return ''
  endif
endfunction

function! assistantAI#ResetPage()
  exec 'setlocal statusline=buf(%n)\ %r[' . s:bufferName . ']%{assistantAI#StatusInfo()}%*'
  set filetype=markdown
  normal 0,$d
  let content = ['',
        \ '## AI', '',
        \ 'v Bito', 'o ChatGPT', '', '',
        \ '## prompt', '']
  call extend(content, s:promptSectionCache)
  call extend(content, [
        \ '', '',
        \ '## question', '',
        \ '以2空白格式化JSON', '', '',
        \ '## anyText', '',
        \   '無效段落，不會被視作問題送出',
        \   '可以當作另類的註解使用', '', '',
        \ '## code', 'ext:json', '',
        \ '{"classmate": ["王小明", "黃小明", "洪小明"]}', '', ''])
  0put = content|+1
endfunction


function! s:parseSection()
  " 讀取檔案內容
  " let content = readfile(expand('%'))
  let content = getline(1, '$')

  " 分隔段落
  let ai = ''
  let promptSection = []
  let questionSection = []
  let codeSection = []
  let filetype = ''

  let currSection = ''
  let idx = -1
  while idx + 1 < len(content)
    let idx += 1
    let line = content[idx]
    if line =~ '^ *$'
      continue
    elseif line == '## AI'
      let currSection = 'ai'
    elseif line == '## prompt'
      let currSection = 'prompt'
    elseif line == '## question'
      let currSection = 'question'
    elseif line == '## code'
      let currSection = 'code'

      if content[idx + 1] =~ '^ext:\w\+$'
        let idx += 1
        let filetype = content[idx][4:]
      endif
    elseif line =~ '^## .*$'
      let currSection = ''
      continue
    else
      if currSection == 'ai' && line =~ s:regexChooseAi
        " as /v (.+)/
        let ai = matchstr(line, 'v\s\zs.\+')
      elseif currSection == 'prompt'
        call add(promptSection, line)
      elseif currSection == 'question'
        call add(questionSection, line)
      elseif currSection == 'code'
        call add(codeSection, line)
      endif
    endif
  endwhile

  return {'ai': ai,
        \ 'prompt': promptSection,
        \ 'question': questionSection,
        \ 'filetype': filetype,
        \ 'code': codeSection}
endfunction

function! s:getQuestionInfo(sections)
  if !empty(a:sections['prompt'])
    let s:promptSectionCache = a:sections['prompt']
    let question = []
    call extend(question, s:promptSectionCache)
    call extend(question, a:sections['question'])
  elseif !empty(s:promptSectionCache)
    let question = []
    call extend(question, s:promptSectionCache)
    call extend(question, a:sections['question'])
  else
    let question = a:sections['question']
  endif

  let isHasCode = !empty(a:sections['code'])
  if isHasCode
    call add(question, '{{%input%}}')
  endif

  let isHasFiletype = !empty(a:sections['filetype'])
  let ext = isHasFiletype ? '.' . a:sections['filetype'] : ''

  return {'ai': a:sections['ai'],
        \ 'question': question,
        \ 'isHasCode': isHasCode,
        \ 'isHasFiletype': isHasFiletype,
        \ 'filetype': a:sections['filetype'],
        \ 'ext': ext,
        \ 'codeFilePath': s:codeFilePath . ext,
        \ 'code': a:sections['code']}
endfunction


function! s:previewTextLines(questionInfo)
  let lines = []
  call add(lines, '## 指定 AI： ' . a:questionInfo['ai'])
  call add(lines, '## 問題：')

  for line in a:questionInfo['question']
    call add(lines, '  ' . line)
  endfor

  if a:questionInfo['isHasCode']
    call add(lines, '## 附件文件' . (a:questionInfo['isHasFiletype']
          \  ? a:questionInfo['ext'] : '')
          \ . '：')

    let code = "\n  " . join(a:questionInfo['code'], "\n  ")

    let letterCount = 0
    for line in a:questionInfo['code']
      let letterCount += len(line)
      if (letterCount < 360)
        call add(lines, '  ' . line)
      else
        call add(lines, '  ' . line . '...')
        break
      endif
    endfor
  endif
  return lines
endfunction

function! assistantAI#Preview()
  if bufnr('%') != s:bufferIndex
    echoerr '請於 ' . s:bufferName . ' 頁時調用此命令'
    return
  endif

  let sections = s:parseSection()
  if empty(sections['ai'])
    echoerr '未指定AI'
    return
  endif
  if empty(sections['question'])
    echoerr '未收到提交的問題'
    return
  endif

  let questionInfo = s:getQuestionInfo(sections)
  let previewTextLines = s:previewTextLines(questionInfo)

  if s:previewBufferIndex == -1
    let s:previewBufferIndex = nvim_create_buf(0, 1)
    call nvim_buf_set_option(s:previewBufferIndex, 'filetype', 'markdown')
  endif
  call nvim_buf_set_lines(
        \ s:previewBufferIndex, 0, -1, v:false, previewTextLines)

  let winSize = s:calcWindowSize(previewTextLines, 79)
  let s:previewFloatWinIndex = nvim_open_win(s:previewBufferIndex, 0, {
        \ 'relative': 'cursor',
        \ 'row': 0,
        \ 'col': 0,
        \ 'width': winSize[0],
        \ 'height': winSize[1],
        \ 'style': 'minimal',
        \ 'border': 'single'})

  " 參考 vim-translator/autoload/translator/window/float.vim
  " 只執行一次的事件
  augroup close_assistantAI_preview_window
    autocmd CursorMoved,BufLeave <buffer>
          \ :call timer_start(100, {
          \   -> function('s:closeFloatWindow', [s:previewFloatWinIndex])() })
          \ | autocmd! close_assistantAI_preview_window
  augroup END
endfunction


function! assistantAI#Send()
  if s:aiRequestLock
    echoerr '目前已有AI請求執行中'
    return
  endif
  call s:setAiRequestLock(v:true)

  let sections = s:parseSection()
  if empty(sections['ai'])
    echoerr '未指定AI'
    return
  endif
  if empty(sections['question'])
    echoerr '未收到提交的問題'
    return
  endif

  let questionInfo = s:getQuestionInfo(sections)
  let s:answerCount += 1

  call nvim_buf_set_option(s:bufferIndex, 'modifiable', v:true)
  call nvim_buf_set_lines(s:bufferIndex, -1, -1, v:true, [
        \ '', '',
        \ '## ' . sections['ai'] . "'s answer #" . s:answerCount, '', ''])
  call nvim_buf_set_option(s:bufferIndex, 'modifiable', v:false)
  let s:aiWriteLine = line('$')
  exec 'normal ' s:aiWriteLine . 'Gzt'

  if sections['ai'] == 'Bito'
    call s:requestBitoAI(questionInfo)
  endif
endfunction


" Bito
" * https://youtu.be/UvGUAn5ua3c
" * https://github.com/gitbito/CLI
" > 首先請先執行 `./bito` 進行登錄
function! s:requestBitoAI(questionInfo)
  let isHasCode = a:questionInfo['isHasCode']
  let isHasFiletype = a:questionInfo['isHasFiletype']
  let codeFilePath = a:questionInfo['codeFilePath']
  if isHasCode
    call writefile(a:questionInfo['code'], codeFilePath)
  endif
  call writefile(a:questionInfo['question'], s:questionFilePath)

  if !isHasCode
    let cmd = 'echo "" | bito -p "' . s:questionFilePath . '"'
  elseif !isHasFiletype
    let cmd = 'cat "' . codeFilePath . '"'
          \ . ' | bito -p "' . s:questionFilePath . '"'
  else
    let cmd = ['bito', '-p', s:questionFilePath, '-f', codeFilePath]
  endif

  let s:aiRequestId = jobstart(cmd, {
        \ 'on_stdout': function('s:aiCmd_onStdout'),
        \ 'on_exit': function('s:aiCmd_onExit'),
        \ 'stdout_buffered': v:false})
  let s:aiWriteLine = line('$')
endfunction


function! assistantAI#Ask()
  let l:lsBuf = filter(range(1, bufnr('$')), 'buflisted(v:val)')

  " if 緩衝區不在當前標籤頁中
  if index(tabpagebuflist(), s:bufferIndex) == -1
    vsplit
    wincmd L

    if index(l:lsBuf, s:bufferIndex) != -1
      exec 'buffer' . s:bufferIndex
    else
      if empty(s:promptSectionCache)
        let s:promptSectionCache = g:defaultPrompt
      endif

      " nvim_create_buf(listed, scratch)
      "   listed 若為 1，則會添加到緩衝區列表 `:ls` 中。
      "   scratch 若為 1，則為臨時緩衝區。將忽略對保存文件的請求。
      "     事後指定忽略保存可使用
      "     `nvim_buf_set_option(bufnr, 'buftype', 'nofile')` 命令
      let s:bufferIndex = nvim_create_buf(1, 1)
      call nvim_buf_set_option(s:bufferIndex, 'filetype', 'markdown')

      exec 'buffer' . s:bufferIndex

      exec 'file ' . s:bufferName . '-' . rand()[0:2]
      call assistantAI#ResetPage()
    endif
  elseif s:bufferIndex == bufnr('%')
    call assistantAI#Send()
    call timer_start(100, { -> assistantAI#Preview() })
  else
    " if 緩衝區在當前標籤頁中
    call win_gotoid(win_findbuf(s:bufferIndex)[0])
  endif
endfunction

noremap <CR>ai :call assistantAI#Ask()<CR>
noremap <CR>airs :call assistantAI#ResetPage()<CR>
noremap <CR>aipv :call assistantAI#Preview()<CR>

