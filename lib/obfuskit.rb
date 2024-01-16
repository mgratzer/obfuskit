#!/usr/bin/env ruby

# Import the necessary modules and files
require_relative 'O'
require 'securerandom'
require 'dotenv'

# Define a module for language constants
module Language
    SWIFT = "Swift"
    KOTLIN = "Kotlin"
end

# Function to generate Swift code
def generate_swift(args)
    # Get the source code for the obfuscator
    obfuscator_source = obfuscator_source('Omin.swift')
    # Generate a random UUID and remove the hyphens
    obfuscation_salt = SecureRandom.uuid.to_s.gsub("-", "")
    # Create a new instance of the O class with the obfuscation salt
    o = O.new("_" + obfuscation_salt)

    # Start building the Swift code
    code = "import Foundation\n\n"
    code += "enum ObfusKit {\n"
    # For each argument, if it's in the environment variables, add it to the code
    args.each_with_index do |arg, index|
        if ENV[arg] != nil 
            code += "\tstatic let #{arg}: String = _o.r(#{o.o(ENV[arg])})\n"
        end
    end
    code += "\n"
    # Add the obfuscation salt and the obfuscator to the code
    code += <<-STRING
\tprivate class _#{obfuscation_salt} { }
\tprivate static let _o = O(String(describing: _#{obfuscation_salt}.self))
}\n\n
STRING

    # Add the obfuscator source code to the code
    code += obfuscator_source
    # Return the generated code
    return code
end

# Function to generate Kotlin code
def generate_kotlin(args)
    # Get the source code for the obfuscator
    obfuscator_source = obfuscator_source('Omin.kt')
    # Generate a random UUID and remove the hyphens
    obfuscation_salt = SecureRandom.uuid.to_s.gsub("-", "")
    # Create a new instance of the O class with the obfuscation salt
    o = O.new("_" + obfuscation_salt)
    
    # Start building the Kotlin code
    code = "object ObfusKit {\n"
    # Add the obfuscation salt and the obfuscator to the code
    code += <<-STRING
\tprivate val _o = O(_#{obfuscation_salt}::class.java.simpleName)
\tprivate class _#{obfuscation_salt}\n
STRING

    # For each argument, if it's in the environment variables, add it to the code
    args.each_with_index do |arg, index|
        if ENV[arg] != nil 
            code += "\tval #{arg}: String = _o.r(byteArrayOf(#{o.o(ENV[arg]).map { |i| i.to_s }.join(', ')}))\n"
        end
    end
    code += "}\n\n"

    # Add the obfuscator source code to the code
    code += obfuscator_source
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

# MAIN

language_map = {
    "swift" => Language::SWIFT,
    "kotlin" => Language::KOTLIN,
    "kt" => Language::KOTLIN
}

Dotenv.load

args = ARGV
first_arg = args.shift

if first_arg != nil && language_map.key?(first_arg.downcase)    
    case language_map[first_arg]
    when Language::SWIFT
        puts generate_swift(args)
    when Language::KOTLIN
        puts generate_kotlin(args)
    end
else
    puts "First argument is not a valid language. Use `swift` or `kotlin`."
end