# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'smarter_dates/version'

Gem::Specification.new do |s|
  s.name        = 'smarter_dates'
  s.version     = SmarterDates::VERSION
  s.authors     = ['Paul Belt']
  s.email       = ['paul.belt@gmail.com']
  s.homepage    = 'http://github.com/belt/smarter_dates'
  s.summary     = %q{Natural language date processing}
  s.description = %q{Humans want to think of date and datetime attributes in a natural manner. Standard ruby Date and DateTime objects do not support this well.}

  s.rubyforge_project = 'smarter_dates'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency('chronic', '~> 0.4.4')
end

