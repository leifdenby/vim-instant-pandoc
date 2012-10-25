vim-instant-pandoc
==================

This a fork of [vim-instant-pandoc] with the following changes/additions:

  [vim-instant-pandoc]: https://github.com/js947/vim-instant-pandoc

- Bibliography, citation-style, update frequency, pandoc binary path and
node-webkit binary path can be set within .vimrc
- Automatic scrolling to follow current cursor position
- Works on Linux and MacOSX
- All content parsing and sending is done in Python
- All path hardlinks removed

An instantly updating previewer for editing [pandoc] files in vim, based on 
[node-webkit].

  [pandoc]: http://johnmacfarlane.net/pandoc/
  [node-webkit]: https://github.com/rogerwang/node-webkit

Credits
-------

Inspired by (and code librally stolen from) the work in `suan`'s 
[instant-markdown-d] and [vim-instant-markdown].

  [instant-markdown-d]: https://github.com/suan/instant-markdown-d
  [vim-instant-markdown]: https://github.com/suan/vim-instant-markdown

Installation
------------

This requires [pandoc] and [node-webkit]. Both are expected to be in `PATH` by
default, but if you have installed these somewhere else their path can be set in
.vimrc (see configuration below).

Latest source is at <https://github.com/leifdenby/vim-instant-pandoc.git>.

There are many different ways to manage and install vim plugins. Use your 
favorite method. If you don't have a favorite method, we recommend using
[Pathogen]. Once you have Pathogen installed, clone this repository into
your
`~/.vim/bundle` directory,

    cd ~/.vim/bundle
    git clone git://github.com/js947/vim-gnuplot.git

In order to make the plugin work, a few more steps are required. Edit 
`plugin/vim-instant-pandoc.vim` to get the correct path to the `bin` directory. 
Also edit `plugin/vim-instant-pandoc.vim` to give the proper location of your 
bibliography and csl style files.

  [Pathogen]: https://github.com/tpope/vim-pathogen

Usage
-----

On opening a pandoc file (`*.{markdown,md,mkd,pd,pdk,pandoc,text}` - the same 
as [vim-pandoc]), a webkit window will open to preview the current document. 


## Configuration
All settings are defined by setting the relevant variable in your `.vimrc` file:

### Preview update frequency
default: `100` (in ms)

	let g:instant_pandoc_update_rate = 100

### Bibliography path
default: `none`

	let g:instant_pandoc_bibliography_path = "/Users/leifdenby/Documents/library.bib"

### Citation-style defitions file path
default: `none`

	let g:instant_pandoc_csl_path =
	"/Users/leifdenby/styles/association-for-computing-machinery.csl"

### Pandoc bin path
default: `pandoc` (this expects pandoc to be in your `PATH`, which if you have
pandoc installed will likely be true).

	let g:instant_pandoc_bin_path = "/Users/leifdenby/bin/pandoc-with-header.sh"

This setting is useful for defining e.g.
a bash-script for further manipulating pandoc output. E.g. the following command
(saved as e.g. `/Users/leifdenby/bin/pandoc-with-header.sh`)

	pandoc --from=markdown --to=markdown --standalone --no-wrap
	--include-in-header=/Users/leifdenby/inc/LaTeX/physics_funcs.sty | pandoc
	--from=markdown --LaTeXmathml

will allow you to include a LaTeX header file, so that you may use e.g. your own
LaTeX expressions in your LaTeX blocks.

### Node-webkit bin path
default: `node-webkit` (MacOSX), `nw` (Linux)

	let g:instant_pandoc_nw_bin_path = "/usr/local/bin/node-webkit"
	let g:instant_pandoc_nw_bin_path =
	"/Users/leifdenby/Applications/node-webkit.app"
