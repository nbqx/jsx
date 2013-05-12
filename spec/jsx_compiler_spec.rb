require 'spec_helper'

describe Jsx::Compiler do
  context "yield test" do
    before do
      @script = fixture_path+'test.jsx'
    end

    it "should pass yield" do
      expect{|b| Jsx::Compiler.compile_with(@script,{:compile => true, :include => []},&b)}.to yield_control
    end
  end
end
