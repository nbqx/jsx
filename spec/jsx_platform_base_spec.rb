require 'spec_helper'
require 'pathname'

describe Jsx::Platform::Base do
  
  context "Platform::Base class" do
    before do
      @cs4 = fixture_path+'cs4.jsx'
      @osx = Jsx::Platform::OSX.new @cs4
      @body = File.open(@cs4).read
    end

    it "should be array with appname and version" do
      @osx.find_target(@body).should eql ['indesign','6.0']
    end
  end

  context "each version" do
    
    before do
      @cs4 = fixture_path+'cs4.jsx'
      @osx = Jsx::Platform::OSX.new @cs4
    end

    it "should be ['indesign','5.0']" do
      @osx.find_target("#target indesign-5.0").should eql ['indesign','5.0']
    end

    it "should be ['indesign','6.0']" do
      @osx.find_target("#target InDesign-6.0").should eql ['indesign','6.0']
    end

    it "should be ['indesign','7.0']" do
      @osx.find_target("#target \"InDesign-7.0\"").should eql ['indesign','7.0']
    end

    it "should be ['indesign','7.5']" do
      @osx.find_target("#target \"InDesign 7.5\"").should eql ['indesign','7.5']
    end

    it "should be ['indesign','8.0']" do
      @osx.find_target("#target 'indesign 8.0'").should eql ['indesign','8.0']
    end

    it "should be ['indesign','0.0']" do
      @osx.find_target("#target 'indesign 0.0'").should eql ['indesign','0.0']
    end

    it "should be ['indesign']" do
      @osx.find_target("#target indesign").should eql ['indesign']
    end

  end

end
