class SSH

  def self.configure(dir)
    ls(dir).each do |file|
      if file == 'config' || file_suffix(file) == '.pub'
        chmod "#{dir}/#{file}", '0644'
      else
        chmod "#{dir}/#{file}", '0600'
      end
      symlink "~/.ssh/#{file}", "#{dir}/#{file}"
    end
  end

end
