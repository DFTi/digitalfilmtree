require 'digitalfilmtree/util'

module Digitalfilmtree
  module Util
    module Mediainfo
      REGEX = {
        :start_timecode => 
          /Time code of first frame\s+\:\s(.+)\n/
      }

      def mediainfo path, key
        raise "Mediainfo bin path unset" unless Mediainfo.bin
        if Util.platform.windows?
          path = Util.safe_path path
        end
        output = `#{Mediainfo.bin} "#{path}"`

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
        os = Util.platform
        if os.windows?
          path = Util.vendored_bin(:mediainfo, :windows, 'MediaInfo.exe')
          Mediainfo.bin = Util.safe_path(path)
        elsif os.mac?
          Mediainfo.bin = Util.vendored_bin(:mediainfo, :mac, 'mediainfo')
        end
      end
    end
  end
end
