# install sshc
git 'https://github.com/troydm/sshc.git', 'sshc'
symlink 'bin/sshc', 'sshc/sshc'

# install Powerline fonts on OSX and Linux only
if os == 'linux'
    install_fontsdir = '~/.fonts'
elsif os == 'osx'
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
  sudo 'cd bin && gcc -o ./powerline -O2 ./powerline.c && strip ./powerline'
end

# install ack
curl 'https://beyondgrep.com/ack-2.18-single-file', 'bin/ack'
chmod 'bin/ack', '0755'

symlink '~/.Xresources', 'Xresources'
symlink '~/.urxvt', 'urxvt'
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
if os == "linux" 
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
