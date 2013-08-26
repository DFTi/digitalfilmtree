require 'fileutils'
require 'edl'

module Digitalfilmtree
  module VFX
    class EDLMLRenamer
      attr_accessor :ml, :edl, :movs
      attr_reader :folder, :count

      def folder=(path)
        @folder = path
        self.ml = self.glob(".txt").first
        self.edl = self.glob(".edl").first
        self.movs = self.glob(".mov")
      end

      def ready?
        self.ml && File.exists?(self.ml) &&
          self.edl && File.exists?(self.edl) &&
          self.movs.size >= 1
      end

      def execute
        raise "Not Ready" unless ready?
        @count = 0
        parse_marker_list
        EDL::Parser.new.parse(File.open(self.edl)).each do |e|
          find_clip(e.reel) do |path|
            timeline_tc_in = e.rec_start_tc.to_s
            get_vfx_name(timeline_tc_in) do |vfx_name|
              new_path = path.gsub(File.basename(path), "#{vfx_name}.mov")
              FileUtils.mv path, new_path
              puts "Renamed #{File.basename(path)} to #{File.basename(new_path)}"
              @count += 1
            end
          end
        end
      end

      protected

      def get_vfx_name timeline_tc_in, &block
        row = @ml_data.select{|r| r.include? timeline_tc_in }
        name = row.flatten.first
        block.call(name) if name
      end

      def find_clip reel, &block
        clip = self.movs.select{|i|i.match(/#{reel}/)}.first
        block.call(clip) if clip && File.exists?(clip)
      end

      def parse_marker_list
        @ml_data = File.read(self.ml).split(/\r\n?|\n/).map{|i|i.split(/\t/)}
      end

      def glob(patt)
        entries = Dir.entries(self.folder).select do |i|
          i.include? patt
        end
        if sep = File::ALT_SEPARATOR
          entries.map do |entry|
            File.join self.folder, sep, entry
          end
        else
          entries.map do |entry|
            File.join self.folder, entry
          end
        end
      end
    end
  end
end
