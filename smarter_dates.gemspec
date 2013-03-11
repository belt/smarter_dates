# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'smarter_dates/version'

Gem::Specification.new do |spec|
  spec.name        = 'smarter_dates'
  spec.version     = SmarterDates::VERSION
  spec.authors     = ['Paul Belt']
  spec.email       = %w(paul.belt@gmail.com)
  spec.homepage    = 'http://github.com/belt/smarter_dates'
  spec.summary     = %q{Natural language date processing}
  spec.description = %q{Humans want to think of date and datetime attributes in a natural manner. Standard ruby Date and DateTime objects do not support this well.}

  spec.rubyforge_project = 'smarter_dates'

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.require_paths = %w(lib)
  spec.required_ruby_version = Gem::Requirement.new('>= 1.8.7')
  spec.required_rubygems_version = Gem::Requirement.new('>= 0') if spec.respond_to? :required_rubygems_version=

  if spec.respond_to? :specification_version
    spec.specification_version = 3
    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0')
      spec.add_runtime_dependency 'chronic', ['>= 0']
      spec.add_development_dependency 'bundler', ['~> 1.3']
      spec.add_development_dependency 'rake', ['>= 0']
    else
      spec.add_dependency('chronic')
    end
  else
    spec.add_dependency('chronic')
  end
end

