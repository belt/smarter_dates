# frozen_string_literal: true

module SmarterDates
  # Base error class for SmarterDates
  class Error < StandardError; end

  # Raised when a value cannot be parsed into a Date/DateTime
  class ParseError < Error
    attr_reader :value

    def initialize(value, message = nil)
      @value = value
      super(message || "cannot parse #{value.inspect} as a date or datetime")
    end
  end
end
