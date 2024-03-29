git 'git@github.com:troydm/dotcentral.git', '.'
require './specifications/font.rb'
require './specifications/ssh.rb'

git 'git@ubuntusrv:troydm/dotcentralprivate.git', 'configurations/private'
run 'configurations/private/configuration.rb'
run 'configurations/common/configuration.rb'
run_if_exists "configurations/#{hostname().gsub(/\.local/,'')}/configuration.rb"
