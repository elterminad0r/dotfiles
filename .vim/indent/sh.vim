" This is my fix for the standard vim runtime function, which causes spurious
" indentation after comments that have Zsh keywords like "if", "then", "case"
" They're hardly uncommon parlance after all

function! GetShIndent()
  let curline = getline(v:lnum)
  let lnum = prevnonblank(v:lnum - 1)
  if lnum == 0
    return 0
  endif
  let line = getline(lnum)

  let pnum = prevnonblank(lnum - 1)
  let pline = getline(pnum)
  let ind = indent(lnum)

  " Check contents of previous lines
  if line =~ '^\s*\%(if\|then\|do\|else\|elif\|case\|while\|until\|for\|select\|foreach\)\>' ||
        \  (&ft is# 'zsh' && line =~ '^\s*[^#\s].*\<\%(if\|then\|do\|else\|elif\|case\|while\|until\|for\|select\|foreach\)\>')
    if !s:is_end_expression(line)
      let ind += s:indent_value('default')
    endif
  elseif s:is_case_label(line, pnum)
    if !s:is_case_ended(line)
      let ind += s:indent_value('case-statements')
    endif
  " function definition
  elseif s:is_function_definition(line)
    if line !~ '}\s*\%(#.*\)\=$'
      let ind += s:indent_value('default')
    endif
  " array (only works for zsh or bash)
  elseif s:is_array(line) && line !~ ')\s*$' && (&ft is# 'zsh' || s:is_bash())
      let ind += s:indent_value('continuation-line')
  " end of array
  elseif curline =~ '^\s*)$'
      let ind -= s:indent_value('continuation-line')
  elseif s:is_continuation_line(line)
    if pnum == 0 || !s:is_continuation_line(pline)
      let ind += s:indent_value('continuation-line')
    endif
  elseif s:end_block(line) && !s:start_block(line)
    let ind -= s:indent_value('default')
  elseif pnum != 0 &&
        \ s:is_continuation_line(pline) &&
        \ !s:end_block(curline) &&
        \ !s:is_end_expression(curline)
    " only add indent, if line and pline is in the same block
    let i = v:lnum
    let ind2 = indent(s:find_continued_lnum(pnum))
    while !s:is_empty(getline(i)) && i > pnum
      let i -= 1
    endw
    if i == pnum
      let ind += ind2
    else
      let ind = ind2
    endif
  endif

  let pine = line
  " Check content of current line
  let line = curline
  " Current line is a endif line, so get indent from start of "if condition" line
  " TODO: should we do the same for other "end" lines?
  if curline =~ '^\s*\%(fi\);\?\s*\%(#.*\)\=$'
    let previous_line = searchpair('\<if\>', '', '\<fi\>', 'bnW')
    if previous_line > 0
      let ind = indent(previous_line)
    endif
  elseif line =~ '^\s*\%(then\|do\|else\|elif\|done\|end\)\>' || s:end_block(line)
    let ind -= s:indent_value('default')
  elseif line =~ '^\s*esac\>' && s:is_case_empty(getline(v:lnum - 1))
    let ind -= s:indent_value('default')
  elseif line =~ '^\s*esac\>'
    let ind -= (s:is_case_label(pine, lnum) && s:is_case_ended(pine) ?
             \ 0 : s:indent_value('case-statements')) +
             \ s:indent_value('case-labels')
    if s:is_case_break(pine)
      let ind += s:indent_value('case-breaks')
    endif
  elseif s:is_case_label(line, lnum)
    if s:is_case(pine)
      let ind = indent(lnum) + s:indent_value('case-labels')
    else
      let ind -= (s:is_case_label(pine, lnum) && s:is_case_ended(pine) ?
                  \ 0 : s:indent_value('case-statements')) -
                  \ s:indent_value('case-breaks')
    endif
  elseif s:is_case_break(line)
    let ind -= s:indent_value('case-breaks')
  elseif s:is_here_doc(line)
    let ind = 0
  " statements, executed within a here document. Keep the current indent
  elseif match(map(synstack(v:lnum, 1), 'synIDattr(v:val, "name")'), '\c\mheredoc') > -1
    return indent(v:lnum)
  elseif s:is_comment(line) && s:is_empty(getline(v:lnum-1))
    return indent(v:lnum)
  endif

  return ind > 0 ? ind : 0
endfunction
