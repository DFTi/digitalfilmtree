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
      let(:originals) { subject.movs.map{|i| Pathname.new(i)} }
      before do
        STDIN.stub(:gets).and_return "0"
        @output = []
        STDOUT.stub(:puts) do |*args|
          @output ||= []
          args.each {|a| @output << a }
        end
        subject.folder = target.path
        originals.each {|i| i.should exist }
      end
      shared_examples_for 'rename' do
        it "renames .mov files in the folder" do
          subject.execute
          originals.each {|i| i.should_not exist }
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
