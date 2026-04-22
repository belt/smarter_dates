# frozen_string_literal: true

require "active_model/type"
require_relative "parser"

module SmarterDates
  # ActiveModel custom types for natural-language date attributes.
  #
  # Auto-registered as `:chronic_date` and `:chronic_datetime` via the
  # Railtie when Rails is present.
  #
  # @example ActiveModel (no database)
  #   class Reminder
  #     include ActiveModel::Attributes
  #     attribute :due_on, SmarterDates::ChronicDateType.new
  #     attribute :remind_at, SmarterDates::ChronicDateTimeType.new
  #   end
  #
  # @example ActiveRecord (auto-registered)
  #   class Activity < ActiveRecord::Base
  #     attribute :birth_d, :chronic_date
  #     attribute :meeting_dt, :chronic_datetime
  #   end
  #
  class ChronicDateType < ActiveModel::Type::Date
    def type = :chronic_date

    def cast(value)
      return value if value.is_a?(::Date) && !value.is_a?(::DateTime)
      Parser.to_date(value)
    end
  end

  class ChronicDateTimeType < ActiveModel::Type::DateTime
    # @see ChronicDateType
    def type = :chronic_datetime

    def cast(value)
      return value if value.is_a?(::DateTime)
      Parser.to_datetime(value)
    end
  end
end
