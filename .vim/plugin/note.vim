if get(g:, 'loaded_note', 0)
  finish
endif

let g:loaded_note = 1

let s:DEFAULT_NOTE_DIRECTORY = '~/Documents/Notes'
let s:DEFAULT_NOTE_FILENAME = '%Y-%m/%d{{ title }}.md'
let s:DEFAULT_NOTE_TEMPLATE = s:DEFAULT_NOTE_DIRECTORY . '/.template.md'

function! s:get_settings(title = '') abort
    let l:note_directory = get(g:, 'note_directory', s:DEFAULT_NOTE_DIRECTORY)
    let l:note_filename = get(g:, 'note_filename', s:DEFAULT_NOTE_FILENAME)
    let l:note_template = get(g:, 'note_template', s:DEFAULT_NOTE_TEMPLATE)
    let l:title = a:title
    let l:ftitle = l:title ==# '' ? '' : '-' . tolower(substitute(l:title, '\s', '-', 'g'))
    let l:filename = expand(l:note_directory . '/' . strftime(substitute(l:note_filename, '{{\s*title\s*}}', l:ftitle, 'g')))
    let l:dir = fnamemodify(l:filename, ':h')

    return {
                \   'filename': l:filename,
                \   'dir': l:dir,
                \   'template': expand(l:note_template),
                \   'title': l:title
                \   }
endfunction

function! s:ensure_dir(dir) abort
    if a:dir !=# ''
        call mkdir(expand(a:dir), 'p')
    endif
endfunction

function! s:open_file(path) abort
    execute 'edit ' . fnameescape(a:path)
endfunction

function! s:apply_template_if_needed(filename, template, title) abort
    if filereadable(expand(a:filename)) || !filereadable(a:template)
        return
    endif

    let l:lines = readfile(a:template)
    if empty(l:lines)
        return
    endif

    call append(0, l:lines)

    let l:replacements = {
                \ '{{\s*date\s*}}': strftime("%x"),
                \ '{{\s*time\s*}}': strftime("%X"),
                \ '{{\s*title\s*}}': a:title !=# '' ? ' ' . a:title : '',
                \ }
    let l:start = 1
    let l:end = line('$')
    for l:i in range(l:start, l:end)
        let l:line = getline(l:i)
        for [l:pat, l:rep] in items(l:replacements)
            let l:line = substitute(l:line, l:pat, l:rep, 'g')
        endfor
        call setline(l:i, l:line)
    endfor
endfunction

function! s:note(title = '') abort
    let l:opts = s:get_settings(a:title)
    call s:ensure_dir(l:opts.dir)
    call s:open_file(l:opts.filename)
    call s:apply_template_if_needed(l:opts.filename, l:opts.template, l:opts.title)
endfunction

command! -nargs=? -complete=file Note silent call s:note(<q-args>)
