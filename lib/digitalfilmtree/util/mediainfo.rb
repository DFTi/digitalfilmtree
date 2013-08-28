module Digitalfilmtree
  module Util
    module Mediainfo
      REGEX = {
        :start_timecode => 
          /Time code of first frame\s+\:\s(.+)\n/
      }

      def mediainfo path, key
        raise "Mediainfo bin path unset" unless Mediainfo.bin
        output = `#{Mediainfo.bin} '#{path}'`
        if key
          output.scan(REGEX[key]).flatten.first
        else
          output
        end
      end

      def self.bin
        @@binpath ||= false
      end

      def self.bin= path
        raise "No such binary #{path}" unless File.exists? path
        @@binpath = path
      end

      def self.autoconfigure
        require 'digitalfilmtree/platform'
        os = Digitalfilmtree.platform
        if os.windows?
          # Might need to install the DLL
          Mediainfo.bin = File.expand_path(
            File.join(
              File.dirname(__FILE__), '..', '..', '..',
              'vendor', 'util', 'mediainfo', 'windows',
              'MediaInfo.exe'
            )).
            gsub(File::SEPARATOR, File::ALT_SEPARATOR || File::SEPARATOR)
        elsif os.mac?
          Mediainfo.bin = File.expand_path(
            File.join(
              File.dirname(__FILE__), '..', '..', '..',
              'vendor', 'util', 'mediainfo', 'mac',
              'mediainfo'
            ))
        end
      end
    end
  end
end
