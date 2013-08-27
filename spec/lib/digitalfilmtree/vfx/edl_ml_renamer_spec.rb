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
        subject.folder = target.path
      end
      shared_examples_for 'rename' do
        it "renames .mov files in the folder" do
          originals.each {|i| i.should exist }
          subject.execute
          originals.each {|i| i.should_not exist }
        end
      end
      context 'name column is not defined' do
        it_behaves_like 'rename'
      end
      context 'name column is predefined' do
        before { subject.ml_name_column = 0 }
        it_behaves_like 'rename'
      end
      after { target.clean.reset }
    end
  end
end
