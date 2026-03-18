# frozen_string_literal: true

require_relative "smarter_dates/version"
require_relative "smarter_dates/error"
require_relative "smarter_dates/parser"

# SmarterDates — natural-language date/datetime attribute parsing.
#
# Date/datetime attributes ending in `_d`, `_on`, `_dt`, or `_at` are
# automatically parsed via {SmarterDates::Parser} (Chronic-backed when
# the gem is available, falling back to Date/DateTime stdlib).
#
# @example ActiveRecord
#   class Activity < ActiveRecord::Base
#     include SmarterDates::ActiveRecordIntegration
#   end
#
# @example Plain Ruby Object
#   class Reminder
#     attr_accessor :due_on, :remind_at
#     include SmarterDates::PlainIntegration
#   end
#
# @example Standalone parser
#   SmarterDates::Parser.to_date("yesterday")
#   SmarterDates::Parser.to_datetime("noon march 15")
#
# @example Opt-in refinements
#   require "smarter_dates/core_ext"
#   using SmarterDates::CoreExt
#   "next friday".to_chronic_date
#
module SmarterDates
  # Lazy-loaded — avoids hard ActiveRecord/ActiveModel dependency at require time
  autoload :ActiveRecordIntegration, "smarter_dates/active_record_integration"
  autoload :PlainIntegration, "smarter_dates/plain_integration"
  autoload :CoreExt, "smarter_dates/core_ext"
  autoload :ChronicDateType, "smarter_dates/type"
  autoload :ChronicDateTimeType, "smarter_dates/type"

  # Backward-compatible mixin: `include SmarterDates` dispatches to the
  # appropriate integration based on whether the host is an AR model.
  def self.included(klass)
    if defined?(::ActiveRecord::Base) && klass < ::ActiveRecord::Base
      klass.include(ActiveRecordIntegration)
    else
      klass.include(PlainIntegration)
    end
  end
end

# Auto-load the validator when ActiveModel is available
require "smarter_dates/validator" if defined?(::ActiveModel)

# Auto-load Rails integration when Rails is present
require_relative "smarter_dates/railtie" if defined?(::Rails::Railtie)
