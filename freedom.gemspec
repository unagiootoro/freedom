require_relative "lib/freedom/version"

Gem::Specification.new do |spec|
  spec.name          = "ruby-freedom"
  spec.version       = Freedom::VERSION
  spec.authors       = ["unagiootoro"]
  spec.email         = ["ootoro838861@outlook.jp"]

  spec.summary       = %q{Tiny web application framework.}
  spec.description   = %q{Freedom is a very simple ruby web application framework.}
  spec.homepage      = "https://github.com/unagiootoro/freedom.git"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  spec.add_dependency "rack"
  spec.add_dependency "rack-protection"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 1.16", "<3.0"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "yard"
end
