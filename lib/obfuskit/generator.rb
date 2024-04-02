# frozen_string_literal: true
require_relative 'obfuscator'
require_relative 'options_parser'
require 'securerandom'
require 'dotenv'
require 'erb'
require 'optparse'

module Obfuskit

  class Generator

    def generate

      parser = OptionsParser.new
      options = parser.parse(ARGV)

      Dotenv.load

      if !options.output_language.nil? && options.env_var_keys.length.positive?

        salt = SecureRandom.uuid.to_s.gsub("-", "")
        obfuscator = Obfuscator.new("_" + salt)

        values = obfuscated_values_from_env(options.env_var_keys, obfuscator)

        if options.output_language == :swift
          puts generate_with_template("swift", values, nil, options.output_type_name, obfuscator)

        elsif options.output_language == :kotlin && !options.package_name.nil?
          puts generate_with_template("kotlin", values, options.package_name, options.output_type_name, obfuscator)

        else
        STDERR.puts parser.parse(%w[--help])
        end

      else
        STDERR.puts parser.parse(%w[--help])
      end
    end

    private

    def obfuscated_values_from_env(args, obfuscator)
      args.map do |name|
        !ENV[name].nil? ? [name, obfuscator.obfuscate(ENV[name])] : nil
      end.compact.to_h
    end

    def generate_with_template(template_name, values, package, type_name, obfuscator)
      file = File.expand_path("templates/#{template_name}.erb", __dir__)
      template = ERB.new(File.read(file), trim_mode: "-")
      template.result_with_hash(
        values: values,
        package: package,
        type_name: type_name,
        salt: obfuscator.salt,
        )
    end

  end
end