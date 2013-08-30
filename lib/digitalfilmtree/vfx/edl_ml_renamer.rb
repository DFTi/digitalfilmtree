require 'digitalfilmtree/model/clip'
require 'fileutils'
require 'edl'

module Digitalfilmtree
  module VFX
    class EDLMLRenamer
      attr_accessor :ml, :edl, :movs, :ml_name_column
      attr_reader :folder, :count

      def folder=(path)
        @folder = path
        self.ml = self.glob(".txt").first
        self.edl = self.glob(".edl").first
        self.movs = self.glob(".mov").map do |path|
          Digitalfilmtree::Model::Clip.new(path)
        end
      end

      def ready?
        self.ml && File.exists?(self.ml) &&
        self.edl && File.exists?(self.edl) &&
        self.movs.size >= 1
      end

      def events
        EDL::Parser.new.parse File.open(self.edl).read
      end

      def execute options={}
        raise "Not Ready" unless ready?
        parse_marker_list
        get_marker_list_name_column
        @count = 0
        binding.pry if $pry_at_parser
        events.each do |e|
          find_clip(e.src_start_tc.to_s) do |clip|
            get_vfx_name(e.rec_start_tc.to_s) do |vfx_name|
              clip.rename_to("#{vfx_name}.mov", options)
              @count += 1
            end
          end
        end
      end

      protected

      def get_marker_list_name_column
        row = @ml_data.first
        loop do
          if self.ml_name_column && row[self.ml_name_column]
            puts "Using marker list column index #{self.ml_name_column} for the Name"
            break
          else
            puts "Please enter the number mapping to the Name column in the marker list:"
            row.each_with_index do |e,i|
              puts "#{i}) #{e}"
            end
            self.ml_name_column = gets.strip.to_i
          end
        end
      end

      def get_vfx_name timecode, &block
        row = @ml_data.select{|r| r.include? timecode }
        name = row.flatten[self.ml_name_column]
        block.call(name) if name
      end

      def find_clip timecode, &block
        clip = self.movs.select do |i|
          i.start_timecode == timecode
        end.first
        block.call(clip) if clip && clip.exists?
      end

      def parse_marker_list
        @ml_data = File.read(self.ml).split(/\r\n?|\n/).map{|i|i.split(/\t/)}
      end

      def glob(patt)
        entries = Dir.entries(self.folder).select do |i|
          i.include? patt
        end
        if sep = File::ALT_SEPARATOR # Windows support
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
