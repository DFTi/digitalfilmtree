#!/usr/bin/env ruby
# This script will run the EDL ML Renamer from wherever it is executed

require 'rubygems'
require 'digitalfilmtree/vfx/edl_ml_renamer'

include Digitalfilmtree

r = VFX::EDLMLRenamer.new
r.folder = Util.winpath File.expand_path File.dirname __FILE__

begin
  Util::Mediainfo.autoconfigure
  if r.ready?
    r.execute
  else
    puts "Not ready. Are you missing .txt, .edl, and/or .mov files?"
    puts "I expect these files to exist in the same directory"
  end
rescue Exception => ex
  puts "Failed. Reason: #{ex.message}"
ensure
  puts "Press enter to quit"
  gets
end
