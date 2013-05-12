# -*- coding: utf-8 -*-
require 'drb/drb'
uri = 'druby://192.168.1.138:12345'

begin
  ind = DRbObject.new_with_uri uri
  ind.run Time.now.strftime("%Y年%m月%d日 %H時%M分%S秒 に実行したよ")
rescue DRb::DRbConnError => e
  puts "#{uri}: サーバが起動してません"
end
