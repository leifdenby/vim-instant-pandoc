function! PandocStart()
  silent !nw /home/js947/.vim/bundle/vim-instant-pandoc/bin &>/dev/null &
endfunction

function! PandocUpdate()
python << EOF
import vim, base64

doc_original = '\n'.join(vim.current.buffer)
doc_encoded  = base64.standard_b64encode(doc_original)
vim.command("let doc_encoded='%s'" % doc_encoded)
EOF

  silent! execute "silent! !echo '" . doc_encoded . "' | curl -X PUT -T - http://localhost:8080/ &> /dev/null"
endfunction

function! PandocEnd()
  silent! !curl -X DELETE http://localhost:8080/ &>/dev/null
endfunction

au BufWinEnter *.{markdown,md,mkd,pd,pdk,pandoc,text} silent call PandocStart()
au BufWinLeave *.{markdown,md,mkd,pd,pdk,pandoc,text} silent call PandocEnd()
au BufWrite,CursorHold,CursorHoldI *.{markdown,md,mkd,pd,pdk,pandoc,text} silent call PandocUpdate()
set updatetime=500
