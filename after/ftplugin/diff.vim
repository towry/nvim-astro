" diff.vim
" This file provides custom mappings and behaviors for the `gf` and `gF` commands
" when working with files that have the `diff` filetype in Neovim.
"
" Features:
" - Overrides `gf` and `gF` mappings to integrate with git-diff-like file structures.
" - Detects and parses paths prefixed by `a/` or `b/` found in git diffs.
" - Ensures proper navigation to files even when they appear in `git diff` format,
"   allowing for seamless exploration within the diff buffer.
"
" Relevant mappings:
" - `gf`: Used to open the file under the cursor.
" - `gF`: Similar to `gf` but uses the full pathname.
"
" Note:
" - This script handles paths with peculiar prefixes (`a/` and `b/`) by checking if
"   the target path is readable or refers to a directory.
" - Includes fallback behavior for paths that do not meet these conditions.

nnoremap <expr> gf  <SID>do_git_diff_aware_gf('gf')
nnoremap <expr> gF  <SID>do_git_diff_aware_gf('gF')

function! s:do_git_diff_aware_gf(command)
  let target_path = expand('<cfile>')
  if target_path =~# '^[ab]/'  " with a peculiar prefix of git-diff(1)?
    if filereadable(target_path) || isdirectory(target_path)
      return a:command
    else
      " BUGS: Side effect - Cursor position is changed.
      let [_, c] = searchpos('\f\+', 'cenW')
      return c . '|' . 'v' . (len(target_path) - 2 - 1) . 'h' . a:command
    endif
  else
    return a:command
  endif
endfunction