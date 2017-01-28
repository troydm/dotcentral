erb 'tmux.conf.erb'
symlink '~/.tmux.conf', 'tmux.conf'
erb 'bashrc.erb'
source '~/.bashrc', 'bashrc'
