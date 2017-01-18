git 'git@ubuntusrv:troydm/dotcentralprivate.git', 'configurations/private'
run 'configurations/common/configuration.rb'
run_if_exists "configurations/#{hostname}/configuration.rb"
