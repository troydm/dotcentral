erb 'tmux.conf.erb'
symlink '~/.tmux.conf', 'tmux.conf'
symlink '~/.local/share/konsole/zenburn.colorscheme', '../common/zenburn.colorscheme'
erb 'bashrc.erb'
source '~/.bashrc', 'bashrc'

git 'https://github.com/troydm/tsundoku.git', 'tsundoku'
symlink 'bin/tsundoku', 'tsundoku/tsundoku'

unless file_exists? 'bin/arc_summary'
  curl 'https://raw.githubusercontent.com/openzfs/zfs/384328e544b1847236a07df231e1b7b10e4cc6ce/cmd/arc_summary/arc_summary.py', 'bin/arc_summary'
  chmod 'bin/arc_summary', '0755'
end
