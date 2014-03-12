Gem::Specification.new do |spec|
  spec.name          = "lita-datadog"
  spec.version       = "0.2.0"
  spec.authors       = ["Eric Sigler"]
  spec.email         = ["me@esigler.com"]
  spec.description   = %q{A Lita handler for interacting with Datadog}
  spec.summary       = %q{Query metrics, events, and generate graphs from Datadog}
  spec.homepage      = "http://github.com/esigler/lita-datadog"
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "handler" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", ">= 3.0"
  spec.add_runtime_dependency "dogapi"
  spec.add_runtime_dependency "chronic"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 3.0.0.beta2"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "coveralls"
end
