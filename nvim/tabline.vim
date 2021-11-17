" Common
function GetBuffers()
  return filter(range(1, bufnr('$')), 'bufexists(v:val) && buflisted(v:val)')
endfunction

function GoToBuffer(n)
  execute 'buffer ' . GetBuffers()[a:n - 1]
endfunction

" Tabline
function TabLine()
  let s = ''
  let buffers = GetBuffers()
  let remainingWidth = -1
  let totalWidth = 0
  let bufferCount = ' ' . len(buffers) . ' '
  let columns = &columns - 1

  for i in range(1, len(buffers))
    let b = buffers[i - 1]
    let isCurrent = b == bufnr('%')
    let isModified = getbufvar(b, '&mod')
    let diagnostics = get(b:, 'coc_diagnostic_info', {})
    let hasError = get(diagnostics, 'error', 0) || get(diagnostics, 'warning', 0)
    let name = fnamemodify(bufname(b), ':t')
    let visible = ' ' . i . ' ' . (name == '' ? '-' : name) . ' '
    let nameLength = strlen(visible)

    if isCurrent && hasError
      let s .= '%#TabLineError#'
    elseif isCurrent && isModified
      let s .= '%#TabLineModifiedSel#'
    elseif isCurrent
      let s .= '%#TabLineSel#'
    elseif isCurrent
      let s .= '%#TabLineModified#'
    else
      let s .= '%#TabLine#'
    endif

    if remainingWidth >= 0 && remainingWidth - nameLength <= 0
      let s .= visible[0:byteidx(visible,remainingWidth+1)-2] . '>'
      break
    else
      if isCurrent
        let centerStart = ((columns - strlen(bufferCount)) / 2) - (nameLength / 2)
        if totalWidth < centerStart
          let remainingWidth = columns - totalWidth - nameLength - strlen(bufferCount)
        else
          let remainingWidth = centerStart
        endif
      else
        let remainingWidth -= nameLength
      endif

      let totalWidth += nameLength
      let s .= visible
    endif
  endfor

  return s . '%#TabLineFill#' . '%=%#TabLineSel#' . bufferCount
endfunction
