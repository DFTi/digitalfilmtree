module Digitalfilmtree
  module Util
    FILE_SEP = File::ALT_SEPARATOR || File::SEPARATOR

    ##
    # Pass a file path through this to fix separators
    def self.safe_path path
      path.gsub(File::SEPARATOR, FILE_SEP)
    end

    ##
    # Grab a vendored binary
    def self.vendored_bin name, platform, filename
      Util.safe_path(File.expand_path(
        File.join(File.dirname(__FILE__), 
                  '..', '..','vendor', 'util', 
                  name.to_s, platform.to_s, filename)))
    end

    ##
    # Introspect about the platform
    def self.platform
      require 'rbconfig'
      @platform ||= Class.new do
        def initialize
          @os = RbConfig::CONFIG['host_os']
        end

        def windows?
          @os =~ /mswin|mingw|cygwin/
        end

        def mac?
          @os =~ /darwin/
        end

        def linux?
          @os =~ /linux/
        end

        def to_s
          @os
        end
      end.new
    end
  end
end
