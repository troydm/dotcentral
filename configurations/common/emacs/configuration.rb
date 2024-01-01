git 'https://github.com/syl20bnr/spacemacs', 'spacemacs.d', depth: 1
git 'https://github.com/hlissner/doom-emacs', 'doomemacs.d', depth: 1

erb 'bashrc.erb'
source '~/.bashrc', 'bashrc'
symlink '~/.spacemacs', 'spacemacs'
symlink '~/.doom.d', 'doom.d'

unless dir_exists? '~/.emacs.d'
  symlink '~/.emacs.d', 'emacs.d'
end
