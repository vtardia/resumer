# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'resumer/info'

Gem::Specification.new do |spec|
  spec.name          = 'resumer'
  spec.version       = Resumer::VERSION
  spec.summary       = 'Resumer creates beautiful CVs from YAML files'
  spec.description   = <<~DESC
    Write your resume once in machine-readable YAML format and export it
    to HTML or PDF using custom themes.
  DESC
  spec.authors       = ['Vito Tardia']

  spec.license       = 'MIT'
  spec.email         = ['vito@tardia.me']
  spec.homepage      = 'https://github.com/vtardia/resumer'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set
  # the 'allowed_push_host' to allow pushing to a single host or
  # delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/vtardia/resumer'
    spec.metadata['changelog_uri'] = 'https://github.com/vtardia/resumer/blob/master/CHANGELOG.md'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir['lib/**/*']
  spec.require_paths = ['lib']
  spec.bindir        = 'bin'
  spec.executables   = ['resumer']

  spec.extra_rdoc_files = Dir['README.md', 'CHANGELOG.md', 'LICENSE.txt']
  spec.rdoc_options += [
    '--title', 'Resumer - beautiful CVs from YAML files',
    '--main', 'README.md',
    '--line-numbers',
    '--inline-source',
    '--quiet'
  ]

  spec.required_ruby_version = '>= 2.6.0'

  spec.add_dependency 'commander', '~> 4.5'
  spec.add_dependency 'kramdown', '~> 2.1'
  spec.add_dependency 'pdfkit', '~> 0.8'

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
