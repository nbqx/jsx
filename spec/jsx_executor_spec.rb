require 'spec_helper'

describe Jsx::Executor do
  context "yield test" do
    before do
      @script = fixture_path+'test.jsx'
    end

    it "should pass yield" do
      expect{|b| Jsx::Executor.run!(@script,&b)}.to yield_control
    end
  end
end
