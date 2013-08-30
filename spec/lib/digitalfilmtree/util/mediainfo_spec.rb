require 'digitalfilmtree/util/mediainfo'

describe Digitalfilmtree::Util::Mediainfo do
  describe "binary path" do
    
    it "is initially unset" do
      subject.bin.should be_false
    end

    context "when set" do
      let(:path) { __FILE__ }
      before { subject.bin = path }
      it "is global to the module" do
        Digitalfilmtree::Util::Mediainfo.bin.should eq path
      end
    end
  end

  let(:platform) { Digitalfilmtree::Util.platform } 

  describe ".autoconfigure" do
    context "on windows" do
      before do
        platform.stub(:mac?).and_return(false)
        platform.stub(:windows?).and_return(true)
      end
      it "sets the binary to the vendored windows exe" do
        subject.autoconfigure
        subject.bin.should match /windows/
      end
    end

    context "on mac" do
      before do
        platform.stub(:mac?).and_return(true)
        platform.stub(:windows?).and_return(false)
      end
      it "sets the binary to the vendored mac binary" do
        subject.autoconfigure
        subject.bin.should match /mac/
      end
    end
  end
end
