# -*- coding: utf-8 -*-
require 'sinatra'
require 'resque'
require './job'

get '/' do
  @info = Resque.info
  puts Resque.queues.inspect
  erb :index
end

post '/' do
  name = params[:name]
  Resque.enqueue(Job,name)
  redirect '/'
end

__END__

@@ index
<html>
  <head><title>Resque With Jsx</title></head>
  <body>
    <p>
      There are <%= @info[:pending] %> pending and <%= @info[:processed] %> processed jobs across <%= @info[:queues] %> queues.
    </p>
    <form method="POST">
      <input type="text" name="name" value="" placeholder="ジョブ名"/>
      <input type="submit" value="追加"/>
    </form>
  </body>
</html>
