Dotfiles
========

Just my 0.02$ to all the dotfile collections.

    archey3             -> config for archey3
    bash                -> my (nearly default) bash config
    i3                  -> (empty) i3 configuration
    htop                -> automaticaly generated htoprc
    reflector[etc]      -> updates pacman's mirrorlist once a week with German mirrors
    urxvt               -> urxvt config
    vim                 -> .vimrc I got from somewhere I forgot
    xinit               -> .xinitrc and .xprofile for use with lightdm and hlwm/i3

All files created on ArchLinux 64Bit machine.
Filemanagement is done with GNU stow.


Install
-------

* checkout to ~/.dotfiles/:
    
        $ git clone https://github.com/tryone144/dotfiles.git ~/.dotfiles

* cd to ~/.dotfiles/:

        $ cd ~/.dotfiles/

* use stow FOLDER to symlink configfiles for a specific programm (for example
vim):

        $ stow vim

* to remove the symlinks use stow -D FOLDER (vim again):

        $ stow -D vim

The folders with [etc] mark need to be linked to /etc/ on your system. To do so
use stow with the -t DIR option (reflector this time):

    $ sudo stow -t / reflector


Warnings
--------

There is a "bug" (seems to be an inteded feature) in systemd, that prevents
systemctl from enabling symlinked .service files.

* *reflector* needs to be copied by hand.


License
-------

The MIT License (MIT)

Copyright (c) 2014 Bernd Busse

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

