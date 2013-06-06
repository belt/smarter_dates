begin
  if RbConfig::CONFIG['RUBY_PROGRAM_VERSION'] == '1.9.3'
    require 'debugger'
  else
    require 'ruby-debug'
  end
rescue LoadError => _
end
