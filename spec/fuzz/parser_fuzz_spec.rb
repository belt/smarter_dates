# frozen_string_literal: true

require "rantly"
require "rantly/rspec_extensions"

RSpec.describe SmarterDates::Parser, :fuzz do
  describe ".to_datetime" do
    it "never raises on arbitrary alphanumeric input" do
      property_of {
        sized(64) { string(:alnum) }
      }.check(200) do |str|
        expect { described_class.to_datetime(str) }.not_to raise_error
      end
    end

    it "returns either nil or a DateTime for printable input" do
      property_of {
        sized(64) { string(:print) }
      }.check(200) do |str|
        result = described_class.to_datetime(str)
        expect(result.nil? || result.is_a?(DateTime)).to be true
      end
    end

    it "round-trips ISO 8601 dates" do
      property_of {
        [range(1900, 2100), range(1, 12), range(1, 28)]
      }.check(100) do |year, month, day|
        iso = format("%04d-%02d-%02d", year, month, day)
        result = described_class.to_date(iso)
        expect(result).to eq(Date.new(year, month, day))
      end
    end
  end
end
