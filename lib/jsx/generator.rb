# -*- coding: utf-8 -*-
require 'pathname'
require 'sprockets'
require 'tmpdir'

module Jsx
  extend self

  class JsxDirectiveProcessor < Sprockets::DirectiveProcessor

    HEADER_PATTERN = /
  \A (
    (?m:\s*) (
      (\#.* \n?)+
    )
  )+
  /x

    DIRECTIVE_PATTERN = /
  ^\#(\w+.*?) (\*\/)? $
  /x

    def prepare
      @pathname = Pathname.new(file)

      @header = data[HEADER_PATTERN, 0] || ""
      @body   = $' || data
      # Ensure body ends in a new line
      @body  += "\n" if @body != "" && @body !~ /\n\Z/m

      @included_pathnames = []
      @compat             = false
    end

    # Returns the header String with any directives stripped.
    def processed_header
      lineno = 0
      @processed_header ||= header.lines.map { |line|
        lineno += 1

        # Replace directive line with a clean break
        # Replace `#target` line with collect target application name

        unless directives.assoc(lineno).nil?
          "\n"
        else
          
          line.scan(/^(\#target) (\S+.*?)$/) do |m1,m2|
            _app_name = m2.split(/[\-|\s]/).map{|x| x.gsub(/['|"|;]/,"").downcase}
            _reg_name = Jsx::CS::REG_NAME[_app_name[0]]
            raise Jsx::Platform::UndeterminedApplicationError if _reg_name.nil?
            _vers = Jsx::CS::VERSIONS[_app_name[0]].invert
            _app_ver = (_app_name.size==1)? _vers[Jsx::CS::DEFAULTS[_app_name[0]]] : _app_name[1]
            line = line.gsub(m2,"#{_reg_name}-#{_app_ver}")
          end
          
          line
        end
      }.join.chomp
    end

    def directives
      @directives ||= header.lines.each_with_index.map { |line, index|
        if directive = line[DIRECTIVE_PATTERN, 1]
          name, *args = Shellwords.shellwords(directive)
          *args = *args.map{|x| x.gsub(";","")} ## against semi-colon
          if respond_to?("process_#{name}_directive", true)
            [index + 1, name, *args]
          end
        end
      }.compact
    end

    def process_include_directive(path)
      pathname = context.resolve(path)
      context.depend_on_asset(pathname)
      included_pathnames << pathname
    end

    def process_require_underscore_directive
      pathname = context.resolve 'underscore.js'
      context.depend_on_asset pathname
      included_pathnames << pathname
    end

  end

  class Generator
    attr_reader :path

    def initialize path, opt={:include => []}
      @original_path = Pathname.new(path).expand_path
      @main_script = @original_path.basename

      @include_dir = Pathname.new(File.dirname(__FILE__)+'/../../vendor')
      @append_paths = opt[:include].map{|x| Pathname.new x}
      @with_directory = opt[:with_directory]

      prepare_tmpdir
      prepare_env
    end

    def generate!
      prepare_manifest
    end

    def body
      @env[@main_script]
    end

    def path
      @env[@main_script].pathname
    end

    def destroy!
      FileUtils.remove_entry_secure @tmpdir, true
    end

    private

    def prepare_tmpdir
      @tmpdir = Dir.mktmpdir

      ## メインのスクリプトと同階層のディレクトリにあるものも@tmpdirにコピーする
      if @with_directory
        Dir.glob("#{@original_path.dirname}/**/**").each do |o|
          pathname = Pathname.new o
          FileUtils.cp_r(pathname,@tmpdir)
        end
      else
        FileUtils.copy(@original_path,@tmpdir)
      end

      Dir.glob("#{@include_dir}/**/**").each do |f|
        jsx = Pathname.new(f)
        FileUtils.copy(jsx.expand_path,@tmpdir)
      end
    end

    def prepare_env
      @env = Sprockets::Environment.new @tmpdir
      @env.register_mime_type 'application/javascript','.jsx'
      @env.unregister_processor 'application/javascript', Sprockets::DirectiveProcessor
      @env.register_processor 'application/javascript', Jsx::JsxDirectiveProcessor
      
      @append_paths.each do |ap|
        Dir.glob("#{ap}/**/**").each do |f|
          jsx = Pathname.new f
          FileUtils.cp_r(jsx.expand_path, @tmpdir)
        end
      end

      @env.append_path @tmpdir

    end

    def prepare_manifest
      @files = Dir.glob('#{@tmpdir}/**/**').select{|x| File.file? x}.map{|x| File.basename x}
      @manifest = Sprockets::Manifest.new @env, @tmpdir
      @manifest.compile @files
    end

  end

end
