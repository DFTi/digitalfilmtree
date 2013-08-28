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
      let(:originals) { subject.movs }

      before do
        @output = []
        Digitalfilmtree::Util::Mediainfo.autoconfigure
        subject.stub(:gets).and_return "0"
        subject.stub(:puts) {|a| @output << a }
        subject.folder = target.path
        originals.each do |clip|
          clip.stub(:puts) do |*args|
            args.each {|a| @output << a }
          end
          clip.should_not be_renamed
        end
      end

      shared_examples_for 'rename' do
        it "renames .mov files in the folder" do
          subject.execute
          originals.each do |i|
            i.should be_renamed
            i.should exist
          end
          @output[-3..-1].should eq [
            "Renamed V1-0003_A013C007_130724_R2LG.mov to NLA098_01_02.mov",
            "Renamed V1-0004_B016C005_130724_R2M9.mov to NLA098_01_03.mov",
            "Renamed V1-0005_A013C008_130724_R2LG.mov to NLA098_01_04.mov"]
        end
      end

      context 'name column is not defined' do
        it_behaves_like 'rename'
        it "requests the marker list name column" do
          subject.execute
          @output[0].should match /enter the number mapping/
        end
      end

      context 'name column is predefined' do
        before { subject.ml_name_column = 0 }
        it_behaves_like 'rename'
      end

      after { target.clean.reset }
    end
  end
end
