if linux?
  symlink '~/.config/compton.conf', 'compton.conf'
  symlink '~/.wallpapers', 'wallpapers'
  symlink '~/.config/polybar', 'polybar'
  symlink '~/.local/share/konsole/zenburn.colorscheme', '../common/zenburn.colorscheme'
  
  # install FontAwesome
  install_fontsdir = '~/.fonts'
  git 'https://github.com/FortAwesome/Font-Awesome.git', 'fontawesome', branch: 'v4.7.0'
  mkdir install_fontsdir
  ls('fontawesome',file: false).each { |fontdir|
    ls("fontawesome/#{fontdir}",grep: '.[ot]tf').each { |font|
      symlink "#{install_fontsdir}/#{font}", "fontawesome/#{fontdir}/#{font}"
    }
  }
  
  run 'xmonad/configuration.rb'
end
