" Delete buffer while keeping window layout (don't close buffer's windows).
" Version 2008-11-18 from http://vim.wikia.com/wiki/VimTip165
" With additional changes from Dmitry Geurkov (troydm) <d.geurkov@gmail.com>
if v:version < 700 || exists('loaded_bclose') || &cp
  finish
endif
let loaded_bclose = 1
if !exists('bclose_multiple')
  let bclose_multiple = 1
endif

" Display an error message.
function! s:Warn(msg)
  echohl ErrorMsg
  echomsg a:msg
  echohl NONE
endfunction

" Counts listed buffers
function! s:CountListedBuffers()
  let cnt = 0
  for nr in range(1,bufnr("$"))
    if buflisted(nr)
      let cnt += 1
    endif
  endfor
  return cnt 
endfunction 

function! s:EndsWith(s1,s2)
    let ind = strridx(a:s1,a:s2)
    if ind >= 0
        let ind = strlen(a:s1) - ind
        return (strlen(a:s2)-ind) == 0
    endif
    return 0
endfunction

" Command ':Bclose' executes ':bd' to delete buffer in current window.
" The window will show the alternate buffer (Ctrl-^) if it exists,
" or the previous buffer (:bp), or a blank buffer if no previous.
" Command ':Bclose!' is the same, but executes ':bd!' (discard changes).
" An optional argument can specify which buffer to close (name or number).
function! s:Bclose(bang, buffer)
  if empty(a:buffer)
    if s:CountListedBuffers() == 0
      execute 'bdelete'.a:bang
      return
    else
      let btarget = bufnr('%')
    endif 
  elseif a:buffer =~ '^\d\+$'
    let btarget = bufnr(str2nr(a:buffer))
  else
    let btarget = bufnr(a:buffer)
  endif
  if bufname(btarget) == '[Command Line]'
    execute "normal \<c-c>"
    return
  endif
  if match(bufname(btarget),'__Gundo') == 0
    execute 'GundoToggle'
    return
  endif
  if btarget < 0
    call s:Warn('No matching buffer for '.a:buffer)
    return
  endif
  if empty(a:bang) && getbufvar(btarget, '&modified')
    call s:Warn('No write since last change for buffer '.btarget.' (use :Bclose!)')
    return
  endif
  " Numbers of windows that view target buffer which we will delete.
  let wnums = filter(range(1, winnr('$')), 'winbufnr(v:val) == btarget')
  if !g:bclose_multiple && len(wnums) > 1
    call s:Warn('Buffer is in multiple windows (use ":let bclose_multiple=1")')
    return
  endif
  let wclose = s:EndsWith(bufname(btarget),'.git/index') ||  s:EndsWith(bufname(btarget),'.git/COMMIT_EDITMSG') 
  let wbuftype = getbufvar(btarget,'&buftype')
  if wbuftype == 'help' || wbuftype == 'quickfix' || wbuftype == 'nofile' || wbuftype == 'nowrite'
    let wclose = 1
  endif
  let wcurrent = winnr()
  for w in wnums
    execute w.'wincmd w'
    let prevbuf = bufnr('#')
    if prevbuf > 0 && buflisted(prevbuf) && prevbuf != w
      buffer #
    else
      bprevious
    endif
    if btarget == bufnr('%')
      " Numbers of listed buffers which are not the target to be deleted.
      let blisted = filter(range(1, bufnr('$')), 'buflisted(v:val) && v:val != btarget')
      " Listed, not target, and not displayed.
      let bhidden = filter(copy(blisted), 'bufwinnr(v:val) < 0')
      " Take the first buffer, if any (could be more intelligent).
      let bjump = (bhidden + blisted + [-1])[0]
      if bjump > 0
        execute 'buffer '.bjump
      else
        execute 'enew'.a:bang
      endif
    endif
  endfor
  execute 'silent! bdelete'.a:bang.' '.btarget
  if wclose
    execute wcurrent.'wincmd q'
  else
    execute wcurrent.'wincmd w'
  endif
endfunction
command! -bang -complete=buffer -nargs=? Bclose call <SID>Bclose('<bang>', '<args>')
nnoremap <silent> <Leader>bd :Bclose<CR>
