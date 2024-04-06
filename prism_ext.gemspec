# frozen_string_literal: true

require_relative "lib/prism_ext/version"

Gem::Specification.new do |spec|
  spec.name = "prism_ext"
  spec.version = PrismExt::VERSION
  spec.authors = ["Richard Huang"]
  spec.email = ["flyerhzm@gmail.com"]

  spec.summary = "extend ruby prism"
  spec.description = "extend ruby prism"
  spec.homepage = "https://github.com/synvert-hq/prism_ext"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/synvert-hq/prism_ext"
  spec.metadata["changelog_uri"] = "https://github.com/synvert-hq/prism_ext/CHANGELOG"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "prism"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
