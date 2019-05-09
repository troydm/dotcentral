if linux?
  symlink '~/.config/compton.conf', 'compton.conf'
end

erb 'bashrc.erb'
source '~/.bashrc', 'bashrc'
