require "jsx/version"
require "jsx/cs"
require "jsx/generator"
require "jsx/compiler"
require "jsx/executor"

module Jsx
  extend self

  def run! path, opt, &b
    opt = {:compile => true, :include => []}.merge opt
    compile = opt[:compile]

    if compile
      Jsx::Compiler.compile_with(path,opt) do |script_path,script_body|
        Jsx::Executor.run!(script_path,&b)
      end
    else
      Jsx::Executor.run!(path,&b)
    end
  end

  def compile input_path, output_path, opt={}
    out = nil

    unless output_path.nil?
      out = Pathname.new output_path
    end

    Jsx::Compiler.compile_with(input_path,opt) do |script_path,script_body|
      if out.nil?
        puts script_body
      else
        open(out,"w") do |f|
          f.write script_body
        end
      end
    end
  end

end
