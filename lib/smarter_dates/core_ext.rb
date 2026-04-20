# frozen_string_literal: true

require_relative "parser"

module SmarterDates
  # Opt-in refinements for natural-language parsing.
  #
  # Lexically scoped — no global monkey-patching. Activate per-file with
  # `using SmarterDates::CoreExt`.
  #
  # @example
  #   require "smarter_dates/core_ext"
  #   using SmarterDates::CoreExt
  #
  #   "yesterday".to_chronic_date         # => #<Date: ...>
  #   "noon march 15".to_chronic_datetime # => #<DateTime: ...>
  #   "now".to_chronic_time               # => 2026-05-25 ...
  #
  module CoreExt
    refine String do
      # @return [DateTime, nil]
      def to_chronic_datetime
        SmarterDates::Parser.to_datetime(self)
      end

      # @return [Date, nil]
      def to_chronic_date
        SmarterDates::Parser.to_date(self)
      end

      # @return [Time, nil]
      def to_chronic_time
        SmarterDates::Parser.to_time(self)
      end
    end
  end
end
