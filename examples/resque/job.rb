# -*- coding: utf-8 -*-
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../../lib'
require 'resque'
require 'jsx'
require 'tempfile'

Resque.redis = 'localhost:6379'

module Job
  @queue = :default

  def self.perform name
    name = name
    start = Time.now.strftime("%Y年%m月%d日 %H時%M分%S秒")
    tpl = File.read('./tpl.jsx.erb')
    body = ERB.new(tpl).result(binding)
    
    tmp = Tempfile.new ['','.jsx']
    tmp.open
    tmp.write body
    tmp.close

    Jsx.run!(tmp.path, {:compile => true, :with_directory => false}){|out|
      puts out unless out.empty?
    }

    tmp.close!
  end

  def self.before_enqueue(*args)
    puts "before_enqueue"
  end
end
