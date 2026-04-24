# frozen_string_literal: true

RSpec.shared_examples "parses to date" do |input|
  it "#{input.inspect} → Date" do
    expect(SmarterDates::Parser.to_date(input)).to be_a(Date)
  end
end

RSpec.shared_examples "parses to datetime" do |input|
  it "#{input.inspect} → DateTime" do
    expect(SmarterDates::Parser.to_datetime(input)).to be_a(DateTime)
  end
end

RSpec.shared_examples "returns nil for invalid" do |input|
  it "#{input.inspect} → nil" do
    expect(SmarterDates::Parser.to_datetime(input)).to be_nil
  end
end
