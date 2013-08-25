require 'spec_helper'
require 'digitalfilmtree/vfx/edl_ml_renamer'

describe Digitalfilmtree::VFX::EDLMLRenamer do
  describe "#execute" do
    context "missing required files" do
      specify do
        expect{subject.execute}.to raise_error "Not Ready"
      end
    end

    context "required files exist" do
      let(:target) { fixture('vfx/edl_ml_renamer') }
      before do
        subject.folder = target.path
        @originals = subject.movs.map{|i| Pathname.new(i)}
      end
      it "renames .mov files in the folder" do
        @originals.each {|i| i.should exist }
        subject.execute
        @originals.each {|i| i.should_not exist }
      end
      after { target.clean.reset }
    end
  end
end
