vim-instant-pandoc
==================

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

This requires [pandoc] and [node-webkit]. 

Latest source is at <https://github.com/js947/vim-gnuplot.git>.

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
The preview is updated frequently- the exact value can be adjusted in 
`plugin/vim-instant-pandoc.vim`. 

  [vim-pandoc]: https://github.com/vim-pandoc/vim-pandoc
