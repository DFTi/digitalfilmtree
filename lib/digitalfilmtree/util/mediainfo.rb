module Digitalfilmtree
  module Util
    module Mediainfo
      REGEX = {
        :start_timecode => 
          /Time code of first frame\s+\:\s(.+)\n/
      }

      def mediainfo path, key
        output = `mediainfo #{path}`
        if key
          output.scan(REGEX[key]).flatten.first
        else
          output
        end
      end
    end
  end
end
