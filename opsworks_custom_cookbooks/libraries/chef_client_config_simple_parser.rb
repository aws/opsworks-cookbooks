module ChefClientConfigSimpleParser
  def self.get_attribute(config_file, config_attribute)
    ::File.readlines(config_file).each do |config_file_entry|
      if config_file_entry =~ /\A\s*require\s+/
        eval config_file_entry
      elsif config_file_entry =~ /\A\s*#{config_attribute}\s+(.*)\Z/
        return eval $1.gsub(/__FILE__/, "'#{config_file}'")
      end
    end
  end
end
