# frozen_string_literal: true
require_relative 'obfuscator'
require 'securerandom'
require 'dotenv'

module Language
  SWIFT = "Swift"
  KOTLIN = "Kotlin"
end

module Obfuskit

  class Generator

    def generate()

      Dotenv.load
      args = ARGV
      first_arg = args.shift

      language_map = {
        "swift" => Language::SWIFT,
        "kotlin" => Language::KOTLIN,
        "kt" => Language::KOTLIN
      }

      if first_arg != nil && language_map.key?(first_arg.downcase)

        # Generate a random UUID and remove the hyphens
        obfuscation_salt = SecureRandom.uuid.to_s.gsub("-", "")
        # Create a new instance of the O class with the obfuscation salt
        obfuscator = Obfuscator.new("_" + obfuscation_salt)

        case language_map[first_arg]
        when Language::SWIFT
          puts generate_swift(args, obfuscator)
        when Language::KOTLIN
          puts generate_kotlin(args, obfuscator)
        end
      else
        puts "First argument is not a valid language. Use `swift` or `kotlin`."
      end
    end

    private
    # Function to generate Swift code
    def generate_swift(args, obfuscator)
      # Start building the Swift code
      code = "import Foundation\n\n"
      code += "enum ObfusKit {\n"
      # For each argument, if it's in the environment variables, add it to the code
      args.each_with_index do |arg, index|
        if ENV[arg] != nil
          code += "\tstatic let #{arg}: String = _o.r(#{obfuscator.obfuscate(ENV[arg])})\n"
        end
      end
      code += "\n"
      # Add the obfuscation salt and the obfuscator to the code
      code += <<-STRING
\tprivate class _#{obfuscator.salt} { }
\tprivate static let _o = O(String(describing: _#{obfuscator.salt}.self))
}\n\n
STRING

      # Add the obfuscator source code to the code
      code += 'struct O { private let c: [UInt8]; private let l: Int; init(_ s: String) { self.init([UInt8](s.utf8)) }; init(_ c: [UInt8]) { self.c = c; l = c.count }; @inline(__always) func o(_ v: String) -> [UInt8] { [UInt8](v.utf8).enumerated().map { $0.element ^ c[$0.offset % l] } }; @inline(__always) func r(_ value: [UInt8]) -> String { String(bytes: value.enumerated().map { $0.element ^ c[$0.offset % l] }, encoding: .utf8) ?? "" } }'
      # Return the generated code
      return code
    end

    # Function to generate Kotlin code
    def generate_kotlin(args, obfuscator)
      # Get the first argument as the package name
      package = args.shift
      # If no package name is provided, return an empty string
      if package == nil
        puts "No package name provided."
        return nil
      end

      # Start building the Kotlin code
      code = "package #{package}\n\n"
      code += "object ObfusKit {\n"
      # Add the obfuscation salt and the obfuscator to the code
      code += <<-STRING
\tprivate val _o = O(_#{obfuscator.salt}::class.java.simpleName)
\tprivate class _#{obfuscator.salt}\n
STRING

      # For each argument, if it's in the environment variables, add it to the code
      args.each_with_index do |arg, index|
        if ENV[arg] != nil
          code += "\tval #{arg}: String = _o.r(byteArrayOf(#{obfuscator.obfuscate(ENV[arg]).map { |i| i.to_s }.join(', ')}))\n"
        end
      end
      code += "}\n\n"

      # Add the obfuscator source code to the code
      code += 'class O{private val a:ByteArray;private val b:Int;constructor(s:String){a=s.toByteArray(Charsets.UTF_8);b=a.size};fun o(v:String):ByteArray{val d=v.toByteArray(Charsets.UTF_8);return ByteArray(d.size){i->(d[i].toInt() xor a[i%b].toInt()).toByte()}};fun r(value:ByteArray):String{return String(ByteArray(value.size){i->(value[i].toInt() xor a[i%b].toInt()).toByte()},Charsets.UTF_8)}}'
      # Return the generated code
      return code
    end

    # Function to get the source code for the obfuscator
    def obfuscator_source(file_name)
      # Get the full path to the file
      source_file_path = File.expand_path(file_name, __dir__)
      # If the file exists, read and return its contents
      return File.read(source_file_path) if File.exist?(source_file_path)
    end
  end

end