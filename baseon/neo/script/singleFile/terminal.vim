
" 開啟終端機
function! NeoTerminalOpen(...)
  let l:termIndex = get(a:, 1, 0)
  let l:position = get(a:, 2, 'J')

  if l:position ==# 'j'
    silent bel sp
  elseif l:position ==# 'k'
    silent sp
  elseif l:position ==# 'h'
    silent vsp
  elseif l:position ==# 'l'
    silent bel vsp
  elseif l:position ==# 'K'
    silent to sp
  elseif l:position ==# 'H'
    silent to vsp
  elseif l:position ==# 'L'
    silent bo vsp
  else
    " same if l:position == 'J'
    silent bo sp
  endif

  if l:termIndex < 0
    silent terminal
  else
    let l:pattern = 'term://'
    let l:lsBuf = map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'bufname(v:val)')
    " 如果要保留 map，請複製 deepcopy(map) 後再使用
    let l:termList = filter(l:lsBuf, 'match(v:val, pattern) != -1')
    let l:termListLength = len(l:termList)

    if l:termListLength == 0 && l:termIndex == 0
      silent terminal
    elseif l:termIndex < l:termListLength
      let l:lsAll = map(range(1, bufnr('$')), 'bufname(v:val)')
      let l:idxBuf = index(l:lsAll, l:termList[l:termIndex]) + 1
      exec 'silent b' . l:idxBuf
    else
      echom '找不到 ' . l:termIndex . ' 引索的終端機'
    endif
  endif
endfunction

command! -nargs=* NeoTerminalOpen :call NeoTerminalOpen(<f-args>)

