require 'digitalfilmtree/util/mediainfo'

module Digitalfilmtree
  module Model
    class Clip
      include Util::Mediainfo

      attr_reader :path

      def initialize path
        @renamed = false
        @path = path
      end

      def basename
        File.basename(self.path)
      end

      def rename_to name
        new_path = self.path.gsub(self.basename, name)
        FileUtils.mv self.path, new_path
        puts "Renamed #{self.basename} to #{File.basename(new_path)}"
        @path = new_path
        @renamed = true
      end

      def renamed?
        @renamed
      end

      def exists?
        File.exists? self.path
      end

      def start_timecode
        @start_timecode ||= mediainfo(self.path, :start_timecode)
      end
    end
  end
end
