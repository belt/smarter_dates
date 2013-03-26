require File.join('smarter_dates', 'version')
require File.join('smarter_dates', 'parser')
require File.join('smarter_dates', 'chronic_strings')
if defined? ActiveModel
  require File.join('smarter_dates', 'chronic_parsable_validator')
end

