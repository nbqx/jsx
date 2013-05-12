require 'bundler/setup'
require 'jsx'

RSpec.configure do |c|
  def fixture_path
    File.dirname(__FILE__)+'/fixtures/'
  end
end
