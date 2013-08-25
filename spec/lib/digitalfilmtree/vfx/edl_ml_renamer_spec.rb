require 'spec_helper'
require 'digitalfilmtree/vfx/edl_ml_renamer'

describe Digitalfilmtree::VFX::EDLMLRenamer do
  let(:renamer) { subject }

  it "requires a target folder path" do
    renamer.folder = "foo/bar"
    renamer.folder.should eq "foo/bar"
  end

  describe "#execute" do
    context "missing required files" do
      specify do
        expect{renamer.execute}.to raise_error "Not Ready"
      end
    end
  end
end
