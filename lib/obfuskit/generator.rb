# frozen_string_literal: true
require_relative 'obfuscator'
require 'securerandom'
require 'dotenv'
require 'erb'

module Language
  SWIFT = "Swift"
  KOTLIN = "Kotlin"
end

module Obfuskit

  class Generator

    def generate()

      Dotenv.load
      args = ARGV
      language_key = args.shift.downcase

      language_map = {
        "swift" => Language::SWIFT,
        "kotlin" => Language::KOTLIN,
        "kt" => Language::KOTLIN
      }

      if language_key != nil && language_map.key?(language_key)

        salt = SecureRandom.uuid.to_s.gsub("-", "")
        obfuscator = Obfuscator.new("_" + salt)

        case language_map[language_key]
        when Language::SWIFT
          puts generate_swift(args, obfuscator)

        when Language::KOTLIN
          puts generate_kotlin(args, obfuscator)
        end

      else
        STDERR.puts "Please specify a valid language."
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
        ENV[name] != nil ? [name, obfuscator.obfuscate(ENV[name])] : nil
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