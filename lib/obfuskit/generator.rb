# frozen_string_literal: true
require_relative 'obfuscator'
require_relative 'options_parser'
require 'securerandom'
require 'dotenv'
require 'erb'
require 'optparse'

module Obfuskit

  class Generator

    def generate()

      parser = OptionsParser.new
      options = parser.parse(ARGV)

      pp options

      Dotenv.load

      if !options.output_language.nil? && options.env_var_keys.length.positive?

        salt = SecureRandom.uuid.to_s.gsub("-", "")
        obfuscator = Obfuscator.new("_" + salt)

        if options.output_language == :swift
          puts generate_swift(options.env_var_keys, obfuscator)

        elsif options.output_language == :kotlin && !options.package_name.nil?
        puts generate_kotlin(options.env_var_keys, obfuscator)

        else
        STDERR.puts parser.parse(%w[--help])
        end

      else
        STDERR.puts parser.parse(%w[--help])
      end
    end

    private

    def generate_swift(args, obfuscator)
      values = obfuscated_values_from_env(args, obfuscator)
      generate_with_template("swift", values, nil, obfuscator)
    end

    def generate_kotlin(args, obfuscator)
      package = args.shift
      if package == nil
        STDERR.puts "No package name provided."
      else
        values = obfuscated_values_from_env(args, obfuscator)
        generate_with_template("kotlin", values, package, obfuscator)
      end
    end

    def obfuscated_values_from_env(args, obfuscator)
      args.map { |name|
        !ENV[name].nil? ? [name, obfuscator.obfuscate(ENV[name])] : nil
      }.compact.to_h
    end

    def generate_with_template(template_name, values, package, obfuscator)
      file = File.expand_path("templates/#{template_name}.erb", __dir__)
      template = ERB.new(File.read(file), trim_mode: "-")
      template.result_with_hash(
        values: values,
        package: package,
        salt: obfuscator.salt
      )
    end

  end
end