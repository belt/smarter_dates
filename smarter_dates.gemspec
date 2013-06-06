# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'smarter_dates/version'

REQUIREMENTS = {
  runtime: {
    chronic: ['>= 0'] },
  development: {
    bundler: ['~> 1.3'],
    rake: ['>= 0'],
    sqlite3: ['>= 1.3.7'],
    debugger: ['>= 1.6.0'],
    rspec: ['>= 2.13.0'],
    mocha: ['>= 0.13.0'],
    database_cleaner: ['>= 0.9.1'],
    machinist: ['>= 2.0.0'],
    activerecord: ['~> 3.2.13'],
    :'rspec-rails' => ['>= 2.12.0'] }
}

Gem::Specification.new do |spec|
  spec.name        = 'smarter_dates'
  spec.version     = SmarterDates::VERSION
  spec.authors     = ['Paul Belt']
  spec.email       = %w(paul.belt@gmail.com)
  spec.license     = 'MIT'
  spec.homepage    = 'http://github.com/belt/smarter_dates'
  spec.summary     = %q{Natural language date processing}
  spec.description = %q{Humans want to think of date and datetime attributes in a natural manner. Standard ruby Date and DateTime objects do not support this well.}

  spec.rubyforge_project = 'smarter_dates'

  spec.files         = `git ls-files`.split("\n")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w(lib)

  spec.required_ruby_version = Gem::Requirement.new('>= 1.9.2')
  spec.required_rubygems_version = Gem::Requirement.new('>= 0') if spec.respond_to? :required_rubygems_version=

  [:runtime, :development].each do |mode|
    REQUIREMENTS[mode].each do |req,ver|
      if spec.respond_to? :specification_version
        spec.specification_version = 3
        if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0')
          if mode == :runtime
            spec.add_runtime_dependency req.to_s, ver
          else
            spec.add_development_dependency req.to_s, ver
          end
        else
          spec.add_dependency req.to_s, ver
        end
      else
        spec.add_dependency req.to_s, ver
      end
    end
  end

end
