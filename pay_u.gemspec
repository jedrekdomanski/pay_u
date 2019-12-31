lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pay_u/version'

Gem::Specification.new do |spec|
  spec.name          = 'pay_u'
  spec.version       = PayU::VERSION
  spec.authors       = ['Jęderzej Domański']
  spec.email         = ['jedrek.domanski@gmail.com']

  spec.summary       = 'Ruby client for PayU REST API'
  spec.description   = 'Ruby client for PayU REST API'
  spec.homepage      = 'https://github.com/jedrekdomanski/pay_u'
  spec.license       = 'MIT'

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '~> 0.9'
  spec.add_dependency 'faraday_middleware-parse_oj', '~> 0.3.2'

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'vcr', '~> 5.0'
  spec.add_development_dependency 'webmock', '~> 3.7.6'
end
