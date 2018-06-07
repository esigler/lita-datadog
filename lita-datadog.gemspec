Gem::Specification.new do |spec|
  spec.name          = 'lita-datadog'
  spec.version       = '0.11.0'
  spec.authors       = ['Eric Sigler', 'James Fryman']
  spec.email         = ['me@esigler.com', 'james@fryman.io']
  spec.description   = 'A Datadog plugin for Lita'
  spec.summary       = spec.description
  spec.homepage      = 'http://github.com/3dna/lita-datadog'
  spec.license       = 'MIT'
  spec.metadata      = { 'lita_plugin_type' => 'handler' }

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'lita', '>= 4.0'
  spec.add_runtime_dependency 'dogapi'
  spec.add_runtime_dependency 'chronic'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '>= 3.0.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'
end
