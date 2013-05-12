require 'pathname'

module Jsx
  extend self

  module Compiler
    class InvaildEncodingError < StandardError;end

    def self.compile_with path_of_script, opt={}, &b
      script = Jsx::Generator.new path_of_script, opt

      begin
        script.generate!
        yield script.path, script.body if block_given?
      rescue Sprockets::EncodingError => e
        ## Sprockets' preprocess only 'UTF-8' encoding
        raise InvalidEncodingError
        exit
      ensure
        script.destroy!
      end
      
    end

  end

end
