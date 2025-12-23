# frozen_string_literal: true

require_relative "lib/harmonica/version"

Gem::Specification.new do |spec|
  spec.name = "harmonica"
  spec.version = Harmonica::VERSION
  spec.authors = ["Marco Roth"]
  spec.email = ["marco.roth@intergga.ch"]

  spec.summary = "A simple, physics-based animation library for Ruby."
  spec.description = "Ruby implementation of Charm's Harmonica. A simple, efficient spring animation library for smooth, natural motion."
  spec.homepage = "https://github.com/marcoroth/harmonica-ruby"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/releases"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir[
    "harmonica.gemspec",
    "LICENSE.txt",
    "README.md",
    "lib/**/*.rb"
  ]

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
