require File.join('smarter_dates', 'version')
require File.join('smarter_dates', 'parser')
if defined? ActiveModel
  require File.join('smarter_dates', 'chronic_parsable_validator')
end

