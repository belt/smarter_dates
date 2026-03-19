# frozen_string_literal: true

require "active_support/concern"
require_relative "parser"

module SmarterDates
  # ActiveRecord integration for natural-language date attributes.
  #
  # Scans `column_names` for columns ending in `_d`, `_on`, `_dt`, or
  # `_at` and installs writers that route values through
  # {SmarterDates::Parser} before storage.
  #
  #   _d, _on  → parsed and coerced to Date
  #   _dt, _at → parsed and coerced to DateTime
  #
  # Reads return whatever ActiveRecord's normal type casting produces,
  # so column types stay authoritative.
  #
  # @example
  #   class Activity < ActiveRecord::Base
  #     include SmarterDates::ActiveRecordIntegration
  #   end
  #
  #   activity = Activity.new
  #   activity.birth_d = "yesterday"
  #   activity.meeting_dt = "noon march 15"
  #
  module ActiveRecordIntegration
    extend ActiveSupport::Concern

    DATE_SUFFIX_PATTERN = /_(?:d|on)\z/
    DATETIME_SUFFIX_PATTERN = /_(?:dt|at)\z/
    private_constant :DATE_SUFFIX_PATTERN, :DATETIME_SUFFIX_PATTERN

    included do
      _smarter_dates_install_columns
    end

    class_methods do
      # @api private
      def _smarter_dates_install_columns
        column_names.each do |col|
          if col.match?(DATE_SUFFIX_PATTERN)
            _smarter_dates_define_writer(col, :to_date)
          elsif col.match?(DATETIME_SUFFIX_PATTERN)
            _smarter_dates_define_writer(col, :to_datetime)
          end
        end
      end

      # @api private
      def _smarter_dates_define_writer(col, parser_method)
        define_method(:"#{col}=") do |value|
          parsed = SmarterDates::Parser.public_send(parser_method, value)
          write_attribute(col, parsed)
        end
      end
    end
  end
end
