# frozen_string_literal: true

RSpec.describe SmarterDates::ChronicDateType do
  let(:type) { described_class.new }

  it "casts string to Date" do
    expect(type.cast("yesterday")).to eq(Date.today - 1)
  end

  it "passes Date through" do
    d = Date.new(2026, 1, 15)
    expect(type.cast(d)).to eq(d)
  end

  it "returns nil for unparseable" do
    expect(type.cast("garbage")).to be_nil
  end

  it "advertises type as :chronic_date" do
    expect(type.type).to eq(:chronic_date)
  end
end

RSpec.describe SmarterDates::ChronicDateTimeType do
  let(:type) { described_class.new }

  it "casts string to DateTime" do
    expect(type.cast("noon march 15 2026")).to be_a(DateTime)
  end

  it "passes DateTime through" do
    dt = DateTime.new(2026, 1, 15, 12, 0, 0)
    expect(type.cast(dt)).to eq(dt)
  end

  it "advertises type as :chronic_datetime" do
    expect(type.type).to eq(:chronic_datetime)
  end
end
