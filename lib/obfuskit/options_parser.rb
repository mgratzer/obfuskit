# frozen_string_literal: true
require 'optparse'

class OptionsParser
  class ScriptOptions

    attr_accessor :output_language, :env_var_keys, :package_name

    def initialize
      self.output_language = nil
      self.env_var_keys = []
      self.package_name = nil
    end

    def define_options(parser)
      parser.banner = "Usage: obfuskit [options]"
      parser.separator ""
      parser.separator "Specific options:"

      # add additional options
      output_language_option(parser)
      env_var_keys_option(parser)
      package_name_option(parser)

      parser.separator ""
      parser.separator "Common options:"
      # No argument, shows at tail.  This will print an options summary.
      # Try it and see!
      parser.on_tail("-h", "--help", "Show this message") do
        puts parser
        exit
      end

      # Another typical switch to print the version.
      parser.on_tail("-v", "--version", "Show version") do
        puts Obfuskit::VERSION
        exit
      end

    end

    def output_language_option(parser)
      parser.on("-l", "--language [LANGUAGE]", [:swift, :kotlin],
                "Select output language (swift, kotlin). Kotlin requires a package parameter.") do |t|
        self.output_language = t
      end
    end

    def env_var_keys_option(parser)
      parser.on("-k", "--keys SECRET_1,SECRET_2,SECRET_3", Array, "List of environment variable keys") do |list|
        self.env_var_keys = list
      end
    end

    def package_name_option(parser)
      parser.on("-p", "--package [PACKAGE]", "Package name for Kotlin") do |package_name|
        self.package_name = package_name
      end
    end
  end

  #
  # Return a structure describing the options.
  #
  def parse(args)
    # The options specified on the command line will be collected in
    # *options*.

    @options = ScriptOptions.new
    @args = OptionParser.new do |parser|
      @options.define_options(parser)
      parser.parse!(args)
    end
    @options
  end

  attr_reader :parser, :options
end  # class OptionsParser
