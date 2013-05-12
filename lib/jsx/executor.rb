# -*- coding: utf-8 -*-
require 'tempfile'
require 'pathname'
require 'erb'
require 'open3'

module Jsx
  extend self

  module Platform
    extend self

    class UndeterminedApplicationError < StandardError;end
    class UnknownApplicationVersionError < StandardError;end

    class Base

      def initialize path_of_jsx
        @jsx = Pathname.new path_of_jsx
        @logfile = Tempfile.new ['','.log']
        @jsx_pre_tpl = Pathname.new(File.dirname(__FILE__)+'/../template/append_jsx_pre.erb').read
        @jsx_suf_tpl = Pathname.new(File.dirname(__FILE__)+'/../template/append_jsx_post.erb').read
        @tgt = find_target File.open(@jsx).read

        raise UndeterminedApplicationError if @tgt.nil?

        create_append_jsx
        create_run_script
      end

      def find_target body
        ret = nil
        body.force_encoding('UTF-8').scan(/^(\#target) (\S+.*?)$/u) do |m1,m2|
          ret = m2.split(/[\-|\s]/).map{|x| x.gsub(/['|"|;]/,"").downcase}
        end
        ret
      end

      def do_exec cmd, &b
        ret = {:success => true, :message => '', :output => ''}

        begin
          stdout,stderr,status = Open3.capture3(cmd)
          ret = {:success => false, :message => stderr} unless stderr.empty?
          log = File.open(@logfile.path).read
          ret[:output] = log unless log.empty?

          if block_given?
            yield log,stderr
          else
            return ret
          end

        rescue => e
         ret = {:success => false, :message => e}
        ensure
          @logfile.close!
          @emitter.close!
        end
        
      end
    end

    class OSX < Jsx::Platform::Base
      
      def initialize path_of_jsx
        @line_feed = 'Unix'
        @emitter = Tempfile.new ['','.scpt']
        @scrt_tpl = Pathname.new(File.dirname(__FILE__)+'/../template/applescript.erb').read
        super
      end

      def exec &b
        do_exec "osascript #{@emitter.path}", &b
      end

      def get_app_name
        _app_name = Jsx::CS::REG_NAME[@tgt[0]]
        _ver = (@tgt[1].nil?)? Jsx::CS::DEFAULTS[@tgt[0]] : Jsx::CS::VERSIONS[@tgt[0]][@tgt[1]]
        
        raise UndeterminedApplicationError if _app_name.nil?
        raise UnknownApplicationVersionError if _ver.nil?

        if @tgt[0]=='illustrator'
          "/Applications/Adobe Illustrator #{_ver}/Adobe Illustrator.app"
        else
          ["Adobe",_app_name,_ver].join(' ')
        end

      end

      def get_run_script
        _app_name = @tgt[0]
        if _app_name == 'photoshop' or _app_name == 'illustrator'
          "do javascript \"#{@append_jsx_pre} $.evalFile('#{@jsx.expand_path}'); #{@append_jsx_suf}\""
        else
          "do script \"#{@append_jsx_pre} $.evalFile('#{@jsx.expand_path}'); #{@append_jsx_suf}\" language javascript"
        end
      end

      private
      
      def create_append_jsx
        @append_jsx_pre = ERB.new(@jsx_pre_tpl).result(binding)
        @append_jsx_suf = ERB.new(@jsx_suf_tpl).result(binding)
      end

      def create_run_script
        app_name = get_app_name
        run_script = get_run_script
        @emitter.open
        @emitter.write ERB.new(@scrt_tpl).result(binding)
        @emitter.close
      end

    end

    class Windows < Jsx::Platform::Base

      def initialize path_of_jsx
        @line_feed = 'Windows'
        @emitter = Tempfile.new ['','.js']
        @scrt_tpl = Pathname.new(File.dirname(__FILE__)+'/../template/jscript.erb').read
        super
      end

      def exec &b
        _app_name = @tgt[0]
        ret = ''

        if _app_name == 'indesign'
          do_exec "cscript #{@emitter.path}", &b
        else
          ret = {:success => false, :message => '`Jsx.run!` works only InDesign at Windows platform.'}
        end

        ret
      end

      def get_app_name
        ## inddは InDesign.Application.CS5_Jみたいな => _Jがないとダメみたい
        ## ill,psは Illustrator.Application だけでOKぽい => versionの指定はどうやるの?

        _app_name = Jsx::CS::REG_NAME[@tgt[0]]
        _ver = (@tgt[1].nil?)? Jsx::CS::DEFAULTS[@tgt[0]] : Jsx::CS::VERSIONS[@tgt[0]][@tgt[1]]

        raise UndeterminedApplicationError if _app_name.nil?
        raise UnknownApplicationVersionError if _ver.nil?

        [_app_name,"Application",_ver].join('.')
      end

      def get_run_script

        _app_name = @tgt[0]

        ## indは文字列でevalFileにいれるとダメなのでFileオブジェクトをつかう方式にする
        ## jscriptは改行が展開されるのでonelinerにする
        if _app_name == 'indesign'
          "#{@append_jsx_pre.gsub("\n","")} var __f__ = new File('#{@jsx.expand_path}');$.evalFile(__f__); #{@append_jsx_suf.gsub("\n","")}"
        else
          ## TODO: ill,psは myApp.doScriptがつかえない
          ""
        end
      end

      private

      def create_append_jsx
        @append_jsx_pre = ERB.new(@jsx_pre_tpl).result(binding)
        @append_jsx_suf = ERB.new(@jsx_suf_tpl).result(binding)
      end

      def create_run_script
        app_name = get_app_name
        run_script = get_run_script

        body = ''
        body = ERB.new(@scrt_tpl).result(binding) unless run_script.empty?

        @emitter.open
        @emitter.write body
        @emitter.close
      end

    end

  end

  module Executor
    extend self

    class JsxUnsupportedPlatformError < StandardError;end

    def run! path_of_jsx, &b

      if RUBY_PLATFORM =~ /mswin(?!ce)|mingw|cygwin|bccwin/
        executor = Jsx::Platform::Windows.new path_of_jsx
      elsif RUBY_PLATFORM.downcase.include? 'darwin'
        executor = Jsx::Platform::OSX.new path_of_jsx
      else
        raise JsxUnsupportedPlatformError
      end

      executor.exec &b

    end
  end
end
