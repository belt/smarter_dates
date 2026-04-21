# frozen_string_literal: true

require "active_model"
require_relative "parser"

# ChronicParsableValidator — validates that an attribute can be parsed
# by {SmarterDates::Parser}.
#
# @example
#   class Activity < ActiveRecord::Base
#     validates :birth_d, chronic_parsable: true
#     validates :meeting_dt, chronic_parsable: { datetime: true }
#   end
#
# Options:
#   datetime: true  — require DateTime (default: any parseable date)
#   allow_nil: true — skip when value is nil
class ChronicParsableValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if options[:allow_nil] && value.nil?

    parsed = if options[:datetime]
      SmarterDates::Parser.to_datetime(value)
    else
      SmarterDates::Parser.to_date(value)
    end

    return if parsed

    record.errors.add(
      attribute,
      :not_a_valid_date,
      message: options[:message] || "not a valid Date or DateTime"
    )
  end
end
