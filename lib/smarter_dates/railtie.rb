# frozen_string_literal: true

require "rails/railtie"

module SmarterDates
  # Rails integration: registers custom types and the validator.
  #
  # Loaded automatically when Rails is present.
  #
  class Railtie < Rails::Railtie
    initializer "smarter_dates.register_types" do
      ActiveSupport.on_load(:active_record) do
        require "smarter_dates/type"
        ActiveRecord::Type.register(:chronic_date, SmarterDates::ChronicDateType)
        ActiveRecord::Type.register(:chronic_datetime, SmarterDates::ChronicDateTimeType)
      end

      ActiveSupport.on_load(:active_model) do
        require "smarter_dates/validator"
      end
    end

    initializer "smarter_dates.load_locales" do |app|
      locale_path = File.expand_path("../../config/locales/en.yml", __dir__)
      app.config.i18n.load_path << locale_path if File.exist?(locale_path)
    end
  end
end
