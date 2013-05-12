$LOAD_PATH.unshift File.dirname(__FILE__) + '/../../lib'
require 'thread'
require 'drb/drb'
require 'jsx'
require 'tempfile'

class IndCS5
  def run text
    @text = text
    tpl = File.read('./test.jsx.erb')
    body = ERB.new(tpl).result(binding)

    tmp = Tempfile.new ['','.jsx']
    tmp.open
    tmp.write body
    tmp.close

    Jsx.run!(tmp.path, {:compile => true, :with_directory => false})
    
    tmp.close!
  end
end

Thread.abort_on_exception = true
trap('INT'){ puts "\rBye!";exit}

uri = 'druby://192.168.1.138:12345'
DRb.start_service uri, IndCS5.new
puts DRb.uri
DRb.thread.join
