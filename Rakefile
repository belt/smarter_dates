require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the smarter_dates gem.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the smarter_dates gem.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'SmarterDates'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = 'smarter_dates'
    gemspec.summary = 'machina to automatically parse date/datetime attributes upon assignment.'
    gemspec.description = "Humans want to think of date and datetime attributes in a natural manner.\nStandard ruby Date and DateTime objects do not support this well."
    gemspec.email = 'Paul Belt'
    gemspec.authors = ['Paul Belt']
    gemspec.homepage = 'http://github.com/belt/smarter_dates'
    gemspec.extra_rdoc_files = ['README.rdoc']
    gemspec.rdoc_options = ['--charset=UTF-8']
    gemspec.add_dependency('chronic', '~> 0.2.3')
    gemspec.rubyforge_project = 'smarter_dates'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end

