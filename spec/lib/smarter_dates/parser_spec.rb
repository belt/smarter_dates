# frozen_string_literal: true

RSpec.describe SmarterDates::Parser do
  describe ".to_datetime" do
    include_examples "parses to datetime", "yesterday"
    include_examples "parses to datetime", "april 22 1976"
    include_examples "parses to datetime", "noon march 15"
    include_examples "parses to datetime", "next friday"
    include_examples "parses to datetime", "two weeks ago"
    include_examples "parses to datetime", "2026-01-15"
    include_examples "parses to datetime", "2026-01-15T12:00:00Z"

    it "passes Date through" do
      d = Date.new(1976, 4, 22)
      expect(described_class.to_datetime(d)).to eq(d.to_datetime)
    end

    it "passes DateTime through unchanged" do
      dt = DateTime.new(1976, 4, 22, 12, 0, 0)
      expect(described_class.to_datetime(dt)).to equal(dt)
    end

    it "converts Time to DateTime" do
      t = Time.new(1976, 4, 22)
      expect(described_class.to_datetime(t)).to be_a(DateTime)
    end

    include_examples "returns nil for invalid", nil
    include_examples "returns nil for invalid", ""
    include_examples "returns nil for invalid", "wuff"
    include_examples "returns nil for invalid", "32 April 1976"
    include_examples "returns nil for invalid", "$%$@\#$@"
    include_examples "returns nil for invalid", ("x" * 300) # exceeds MAX_INPUT_LENGTH
  end

  describe ".to_date" do
    include_examples "parses to date", "yesterday"
    include_examples "parses to date", "22 April 1976"

    it "preserves date components for unambiguous input" do
      d = described_class.to_date("22 April 1976")
      expect(d.year).to eq(1976)
      expect(d.month).to eq(4)
      expect(d.day).to eq(22)
    end

    it "returns nil for invalid input" do
      expect(described_class.to_date("safdsafds")).to be_nil
    end
  end

  describe ".to_time" do
    it "returns a Time for valid input" do
      expect(described_class.to_time("noon")).to be_a(Time)
    end
  end

  describe ".parsable?" do
    it "is true for valid input" do
      expect(described_class.parsable?("yesterday")).to be true
    end

    it "is false for invalid input" do
      expect(described_class.parsable?("wuff")).to be false
    end

    it "is false for nil" do
      expect(described_class.parsable?(nil)).to be false
    end
  end

  describe "natural-language coverage" do
    valid_inputs = [
      "yesterday", "12:55 pm", "friday morning", "friday afternoon",
      "april 22 1976", "Thursday", "noon march 15",
      "july 4th", "27 Oct 2006 0730",
      "13th of this month", "December 31st midnight",
      "december 31st 2013 midnight", "third thursday in nov",
      "tomorrow", "in 10 minutes", "2 months from now"
    ]

    valid_inputs.each do |input|
      it "parses #{input.inspect}" do
        expect(described_class.to_datetime(input)).not_to be_nil
      end
    end
  end
end
