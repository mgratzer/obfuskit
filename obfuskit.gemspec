# frozen_string_literal: true

require_relative "lib/obfuskit/version"

Gem::Specification.new do |s|
    s.name        = "obfuskit"
    s.version     = Obfuskit::VERSION
    s.summary     = "Environment variable obfuscation for Swift and Kotlin."
    s.description = "Generate Swift and Kotlin files with obfuscated environment variables."
    s.authors     = ["Martin Gratzer"]
    s.email       = "mgratzer@gmail.com"
    s.homepage    =
      "https://github.com/mgratzer/obfuskit"
    s.license       = "MIT"
    s.executables << "obfuskit"
    s.required_ruby_version = ">= 3.0.0"
    s.metadata["homepage_uri"] = s.homepage

    # Specify which files should be added to the gem when it is released.
    # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
    s.files = Dir.chdir(__dir__) do
        `git ls-files -z`.split("\x0").reject do |f|
            (File.expand_path(f) == __FILE__) ||
              f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
        end
    end
    s.bindir = "exe"
    s.executables = s.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
    s.require_paths = ["lib"]
  end