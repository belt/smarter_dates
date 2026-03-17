# frozen_string_literal: true

require "date"

# Try the maintained gitlab-chronic fork first, then fall back to the
# original chronic gem if a host application has it pinned. Either
# defines the top-level Chronic module.
begin
  require "gitlab-chronic"
rescue LoadError
  begin
    require "chronic"
  rescue LoadError
    # No Chronic gem available — Parser falls back to Date/DateTime.parse
  end
end

module SmarterDates
  # Standalone natural-language date/datetime parser.
  #
  # Type-dispatch design: branches by input class to avoid unnecessary
  # work. Date/DateTime/Time pass through. Strings parse via Chronic (when
  # available) with a Date/DateTime stdlib fallback.
  #
  # No global state, no ActiveRecord dependency.
  #
  # @example Parse natural language
  #   SmarterDates::Parser.to_datetime("yesterday")
  #   # => #<DateTime: 2026-05-24T00:00:00...>
  #
  # @example Parse to a Date
  #   SmarterDates::Parser.to_date("two weeks ago")
  #
  # @example Parse to a Time
  #   SmarterDates::Parser.to_time("noon march 15")
  #
  module Parser
    # Maximum input string length accepted for parsing.
    MAX_INPUT_LENGTH = 256
    private_constant :MAX_INPUT_LENGTH

    module_function

    # Parse a value into a DateTime.
    #
    # @param value [String, Date, DateTime, Time, Numeric, nil]
    # @return [DateTime, nil] nil for unparseable input
    def to_datetime(value)
      case value
      when nil then nil
      when DateTime then value
      when Date then value.to_datetime
      when Time then value.to_datetime
      when Numeric then Time.at(value).to_datetime
      when String then parse_string(value)
      else parse_string(value.to_s)
      end
    end

    # Parse a value into a Date.
    #
    # @param value [String, Date, DateTime, Time, Numeric, nil]
    # @return [Date, nil] nil for unparseable input
    def to_date(value)
      dt = to_datetime(value)
      dt&.to_date
    end

    # Parse a value into a Time.
    #
    # @param value [String, Date, DateTime, Time, Numeric, nil]
    # @return [Time, nil] nil for unparseable input
    def to_time(value)
      dt = to_datetime(value)
      dt&.to_time
    end

    # Predicate: true when the value can be parsed.
    #
    # @param value [Object]
    # @return [Boolean]
    def parsable?(value)
      !to_datetime(value).nil?
    end

    # @api private
    def parse_string(str)
      return nil if str.empty?
      return nil if str.length > MAX_INPUT_LENGTH

      chronic_parse(str) || builtin_parse(str)
    end
    private_class_method :parse_string

    # @api private
    def chronic_parse(str)
      return nil unless defined?(::Chronic)

      result = ::Chronic.parse(str)
      result&.to_datetime
    rescue
      nil
    end
    private_class_method :chronic_parse

    # @api private
    def builtin_parse(str)
      DateTime.parse(str)
    rescue ArgumentError, TypeError
      begin
        Date.parse(str).to_datetime
      rescue ArgumentError, TypeError
        nil
      end
    end
    private_class_method :builtin_parse
  end
end
