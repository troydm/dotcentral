class Font
  if linux?
    if hostname == 'troymac'
      @install_fontsdir = '~/.local/share/fonts'
    else
      @install_fontsdir = '~/.fonts'
    end
    mkdir @install_fontsdir
  elsif osx?
    @install_fontsdir = '~/Library/Fonts'
    mkdir @install_fontsdir
  end

  def self.install(font)
    if @install_fontsdir
      install_font_path = "#{@install_fontsdir}/#{file_name(font)}"
      if linux?
        symlink install_font_path, font
      elsif osx?
        copy font, install_font_path
      end
    end
  end

  def self.nerd_font_download(nerd_font_path, download_folder)
    mkdir download_folder
    download_font_path = "#{download_folder}/#{file_name(nerd_font_path.gsub(' ','_'))}"
    curl "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/#{nerd_font_path.gsub(' ', '%20')}",
      download_font_path, content_length_check: true
    download_font_path
  end

  def self.nerd_font_install(nerd_font_path, to_font_file)
    self.install(self.nerd_font_download(nerd_font_path, to_font_file))
  end

end
