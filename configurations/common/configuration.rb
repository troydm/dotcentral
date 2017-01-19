git 'https://github.com/troydm/sshc.git', 'sshc'
git 'https://github.com/powerline/fonts.git', 'fonts'
mkdir '~/.fonts'
ls('fonts',{:file => false}).each { |fontdir|
    ls("fonts/#{fontdir}",{:grep => '.[ot]tf'}).each { |font|
        symlink "~/.fonts/#{font}", "fonts/#{fontdir}/#{font}"
    }
}
symlink 'bin/sshc', 'sshc/sshc'
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
