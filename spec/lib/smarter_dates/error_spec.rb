# frozen_string_literal: true

RSpec.describe SmarterDates::Error do
  it "is a StandardError" do
    expect(described_class).to be < StandardError
  end
end

RSpec.describe SmarterDates::ParseError do
  it "is a SmarterDates::Error" do
    expect(described_class).to be < SmarterDates::Error
  end

  it "carries the offending value" do
    err = described_class.new("garbage")
    expect(err.value).to eq("garbage")
  end

  it "produces a default message" do
    err = described_class.new("garbage")
    expect(err.message).to include("garbage")
  end

  it "accepts a custom message" do
    err = described_class.new("garbage", "custom message")
    expect(err.message).to eq("custom message")
  end
end
