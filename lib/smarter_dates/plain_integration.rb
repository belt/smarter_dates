# frozen_string_literal: true

require_relative "parser"

module SmarterDates
  # Plain Ruby Object (PORO) integration for natural-language date
  # attributes. Use when the host class is not an ActiveRecord model.
  #
  # Scans `instance_methods` for setters/readers ending in `_d`, `_on`,
  # `_dt`, or `_at` and wraps writers to route through the parser.
  #
  # @example
  #   class Note
  #     attr_accessor :reminder_at, :due_on
  #     include SmarterDates::PlainIntegration
  #   end
  #
  #   note = Note.new
  #   note.due_on = "next friday"     # stored as Date
  #   note.reminder_at = "in 2 hours" # stored as DateTime
  #
  module PlainIntegration
    DATE_SUFFIX_PATTERN = /_(?:d|on)\z/
    DATETIME_SUFFIX_PATTERN = /_(?:dt|at)\z/
    private_constant :DATE_SUFFIX_PATTERN, :DATETIME_SUFFIX_PATTERN

    def self.included(klass)
      klass.instance_methods.each do |meth|
        name = meth.to_s
        if name.match?(DATE_SUFFIX_PATTERN)
          _install_writer(klass, name, :to_date)
        elsif name.match?(DATETIME_SUFFIX_PATTERN)
          _install_writer(klass, name, :to_datetime)
        end
      end
    end

    def self._install_writer(klass, attr, parser_method)
      ivar = :"@#{attr}"
      klass.send(:define_method, :"#{attr}=") do |value|
        parsed = SmarterDates::Parser.public_send(parser_method, value)
        instance_variable_set(ivar, parsed)
      end
    end
    private_class_method :_install_writer
  end
end
