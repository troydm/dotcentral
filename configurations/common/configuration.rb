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


symlink '~/.Xresources', 'Xresources'
symlink '~/.urxvt', 'urxvt'
symlink '~/.dircolors', 'dircolors'
erb 'bashrc.erb'
source '~/.bashrc', 'bashrc'
symlink '~/.gitconfig', 'gitconfig'
symlink '~/.gitignore', 'gitignore'
symlink '~/.tigrc', 'tigrc'
run 'mc/configuration.rb'
run 'vifm/configuration.rb'
run 'vim/configuration.rb'
run 'vimperator/configuration.rb'
