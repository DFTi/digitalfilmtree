module Digitalfilmtree
  module Util
    def self.winpath path
      path.gsub(File::SEPARATOR, File::ALT_SEPARATOR || File::SEPARATOR)
    end

    def self.platform
      require 'digitalfilmtree/platform'
      Digitalfilmtree.platform
    end

    def self.vendored_bin name, platform, filename
      File.expand_path(
        File.join(
          File.dirname(__FILE__), '..', '..',
          'vendor', 'util', name.to_s, 
          platform.to_s, filename
        ))
    end
  end
end