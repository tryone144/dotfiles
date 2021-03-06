#
# BASH
# .profile to set up $PATH and other environment options
# sourced by .bash_profile
# 
# file: ~/.profile
# v1.0 / 2019.04.12
#
# (c) 2019 Bernd Busse
#

# Add binary locations in home folder to path
__RUBY_BIN="$(ruby -e 'puts Gem.user_dir')/bin"
[[ "${PATH}" = *"${__RUBY_BIN}"* ]] || export PATH="$__RUBY_BIN:$PATH"
__NODE_BIN="${HOME}/.node_modules/bin"
[[ "${PATH}" = *"${__NODE_BIN}"* ]] || export PATH="$__NODE_BIN:$PATH"
__RUST_BIN="${HOME}/.cargo/bin"
[[ "${PATH}" = *"${__RUST_BIN}"* ]] || export PATH="$__RUST_BIN:$PATH"
__USER_BIN="${HOME}/.local/bin"
[[ "${PATH}" = *"${__USER_BIN}"* ]] || export PATH="$__USER_BIN:$PATH"

__XTOOLS_RPI_BIN="/opt/arm-rpi-linux-gnueabihf/bin"
[[ "${PATH}" = *"${__XTOOLS_RPI_BIN}"* ]] || export PATH="$PATH:$__XTOOLS_RPI_BIN"

# Disable GTK3 Window borders
export GTK_CSD=0

# Enable GTK for Java Swing applications
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on 
                      -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel 
                      -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'

export SDL_VIDEO_FULLSCREEN_HEAD=0

# Do no use fancy GTK dialog for SSH/GitHub passwords
unset SSH_ASKPASS
