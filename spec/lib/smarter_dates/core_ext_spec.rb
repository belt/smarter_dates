# frozen_string_literal: true

require "smarter_dates/core_ext"

RSpec.describe SmarterDates::CoreExt do
  describe "is opt-in (no global monkey-patch)" do
    it "String#to_chronic_date is not defined globally" do
      expect("yesterday").not_to respond_to(:to_chronic_date)
    end
  end

  describe "with refinements activated" do
    using SmarterDates::CoreExt

    it "parses to Date" do
      expect("yesterday".to_chronic_date).to be_a(Date)
    end

    it "parses to DateTime" do
      expect("noon march 15 2026".to_chronic_datetime).to be_a(DateTime)
    end

    it "parses to Time" do
      expect("noon".to_chronic_time).to be_a(Time)
    end

    it "returns nil for unparseable" do
      expect("garbage".to_chronic_date).to be_nil
    end
  end
end
