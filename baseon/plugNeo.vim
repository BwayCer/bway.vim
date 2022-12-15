
" 標記減量預覽
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }

  nmap <CR>rmd :MarkdownPreview<CR>
  nmap <CR>rmdstop :MarkdownPreviewStop<CR>
  " TODO: 這什麼意思
  " autocmd! User markdown-preview.vim echo '[Bway.Plug] 標記減量預覽 已載入'

