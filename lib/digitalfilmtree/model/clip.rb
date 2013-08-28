module Digitalfilmtree
  module Model
    class Clip
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
    end
  end
end
