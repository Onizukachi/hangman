class WordReader
  def read_from_file(file_name)
    return nil unless File.exist?(file_name)

    File.open(file_name, 'r:UTF-8') do |file| 
      lines = file.readlines
      lines.shuffle!
      lines.sample.chomp
    end
  end
end
