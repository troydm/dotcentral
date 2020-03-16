if linux?
  symlink '~/.config/compton.conf', 'compton.conf'
  mkdir '~/.config/dunst'
  symlink '~/.config/dunst/dunstrc', 'dunstrc'
end

erb 'bashrc.erb'
source '~/.bashrc', 'bashrc'
