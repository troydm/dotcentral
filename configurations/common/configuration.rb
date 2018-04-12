# install sshc
git 'https://github.com/troydm/sshc.git', 'sshc'
symlink 'bin/sshc', 'sshc/sshc'

# install exp
git 'https://github.com/troydm/exp.git', 'exp'
symlink 'bin/exp', 'exp/exp'

# install tldr
git 'https://github.com/pepa65/tldr-bash-client.git', 'tldr'
symlink 'bin/tldr', 'tldr/tldr'

# install Powerline fonts on OSX and Linux only
if linux?
    if hostname == 'troymac'
      install_fontsdir = '~/.local/share/fonts'
    else
      install_fontsdir = '~/.fonts'
    end
elsif osx?
    install_fontsdir = '~/Library/Fonts'
end
if install_fontsdir
  git 'https://github.com/powerline/fonts.git', 'fonts'
  mkdir install_fontsdir
  ls('fonts',{:file => false}).each { |fontdir|
      ls("fonts/#{fontdir}",{:grep => '.[ot]tf'}).each { |font|
          symlink "#{install_fontsdir}/#{font}", "fonts/#{fontdir}/#{font}"
      }
  }
end

# powerline command
unless file_exists? 'bin/powerline'
  if hostname == "troymac"
    shell "nix-shell -p stdenv --pure --command 'cd bin && gcc -o ./powerline -O2 ./powerline.c && strip ./powerline'", {:verbose => true, :silent => false}
  else
    shell 'cd bin && gcc -o ./powerline -O2 ./powerline.c && strip ./powerline', {:verbose => true, :silent => false}
  end
end

# install ack
curl 'https://beyondgrep.com/ack-2.22-single-file', 'bin/ack'
chmod 'bin/ack', '0755'

if linux?
  erb 'Xresources.erb'
  symlink '~/.Xresources', 'Xresources'
  symlink '~/.urxvt', 'urxvt'
end
symlink '~/.hyper.js', 'hyper.js'
symlink '~/.dircolors', 'dircolors'
erb 'bashrc.erb'
source '~/.bashrc', 'bashrc'
if file_exists? '~/.zshrc'
  source '~/.zshrc', 'bashrc'
end
if file_exists? '~/.config/fish/config.fish'
  erb 'fishrc.erb'
  source '~/.config/fish/config.fish', 'fishrc'
end
symlink '~/.gitconfig', 'gitconfig'
symlink '~/.gitignore', 'gitignore'
symlink '~/.tigrc', 'tigrc'
symlink '~/.spacemacs', 'spacemacs'
symlink '~/.cvimrc', 'cvimrc'
symlink '~/.qutebrowser', 'qutebrowser'
if linux?
  if hostname != "troynas"
    symlink '~/.config/redshift.conf', 'redshift.conf'
  end
  symlink '~/.config/vimb', 'vimb'
end
symlink '~/.config/ranger', 'ranger'
run 'mc/configuration.rb'
run 'vifm/configuration.rb'
run 'vim/configuration.rb'
run 'vimperator/configuration.rb'
