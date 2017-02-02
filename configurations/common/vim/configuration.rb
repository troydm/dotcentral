git 'https://github.com/VundleVim/Vundle.vim.git', 'bundle/Vundle.vim'
symlink '~/.vim', pwd
symlink '~/.vimrc', 'vimrc'
symlink '~/.gvimrc', 'gvimrc'
source '~/.bashrc','bashrc'
if file_exists? '~/.zshrc'
  source '~/.zshrc', 'bashrc'
end
