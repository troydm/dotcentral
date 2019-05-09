erb 'tmux.conf.erb'
symlink '~/.tmux.conf', 'tmux.conf'
symlink '~/.local/share/konsole/zenburn.colorscheme', '../common/zenburn.colorscheme'
erb 'bashrc.erb'
source '~/.bashrc', 'bashrc'

git 'https://github.com/troydm/tsundoku.git', 'tsundoku'
symlink 'bin/tsundoku', 'tsundoku/tsundoku'
