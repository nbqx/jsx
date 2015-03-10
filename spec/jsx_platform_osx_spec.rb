require 'spec_helper'
require 'pathname'

describe Jsx::Platform::OSX do
  
  context "Platform::OSX InDesignCS5" do
    before do
      @jsx = fixture_path+'test.jsx'
      @osx = Jsx::Platform::OSX.new @jsx
    end

    it "should be collect application name and version" do
      @osx.get_app_name.should eql 'Adobe InDesign CS5'
    end
  end

  context "Platform::OSX InDesignCS4" do
    before do
      @jsx = fixture_path+'cs4.jsx'
      @osx = Jsx::Platform::OSX.new @jsx
    end

    it "should be collect application name and version" do
      @osx.get_app_name.should eql 'Adobe InDesign CS4'
    end
  end

  context "Platform::OSX InDesign CC" do
    before do
      @jsx = fixture_path+'cc.jsx'
      @osx = Jsx::Platform::OSX.new @jsx
    end

    it "should be collect application name and version" do
      @osx.get_app_name.should eql 'Adobe InDesign CC'
    end
  end

  context "without target-line jsx file" do
    before do
      @jsx = fixture_path+'without_target_line.jsx'
    end

    it "should be UndeterminedApplicationError" do
      expect{Jsx::Platform::OSX.new(@jsx)}.to raise_error(Jsx::Platform::UndeterminedApplicationError)
    end
  end

  context "invalid application name jsx file" do
    before do
      @jsx = fixture_path+'invalid_application_name.jsx'
    end

    it "should be UndeterminedApplicationError" do
      expect{Jsx::Platform::OSX.new(@jsx)}.to raise_error(Jsx::Platform::UndeterminedApplicationError)
    end
  end

end
