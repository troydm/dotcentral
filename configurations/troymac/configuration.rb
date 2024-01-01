if linux?
  symlink '~/.config/picom.conf', 'picom.conf'
  mkdir '~/.config/dunst'
  symlink '~/.config/dunst/dunstrc', 'dunstrc'
end

erb 'bashrc.erb'
source '~/.bashrc', 'bashrc'
