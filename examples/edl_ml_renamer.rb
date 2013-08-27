#!/usr/bin/env ruby
# This script will run the EDL ML Renamer from wherever it is executed

require 'rubygems'

PATH = File.expand_path(File.dirname(__FILE__)).
  gsub(File::SEPARATOR, File::ALT_SEPARATOR || File::SEPARATOR)

require 'digitalfilmtree/vfx/edl_ml_renamer'
r = Digitalfilmtree::VFX::EDLMLRenamer.new
r.folder = PATH

if r.ready?
  STDOUT.puts "Do you want me to rename?"
else
  STDOUT.puts "Not ready. Are you missing .txt, .edl, and/or .mov files?"
end
STDIN.gets

r.execute
