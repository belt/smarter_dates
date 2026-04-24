# frozen_string_literal: true

RSpec.describe ChronicParsableValidator do
  include_context "AR with validator"

  describe "valid input" do
    %w[22-April-1976 today one\ week\ ago yesterday 2026-01-15].each do |input|
      it "accepts #{input.inspect} for birth_d" do
        record.birth_d = input
        record.meeting_dt = "noon"
        record.valid?
        expect(record.errors[:birth_d]).to be_empty
      end
    end
  end

  describe "invalid input" do
    [nil, "", "safdsafds", "55 April 1976", "$%$@\#$@"].each do |input|
      it "rejects #{input.inspect} for birth_d" do
        record.birth_d = input
        record.meeting_dt = "noon"
        record.valid?
        expect(record.errors[:birth_d]).to include("not a valid Date or DateTime")
      end
    end
  end

  describe "datetime: true option" do
    it "rejects values that don't parse to a datetime" do
      record.birth_d = "today"
      record.meeting_dt = "garbage input"
      record.valid?
      expect(record.errors[:meeting_dt]).to include("not a valid Date or DateTime")
    end

    it "accepts a valid datetime string" do
      record.birth_d = "today"
      record.meeting_dt = "noon"
      record.valid?
      expect(record.errors[:meeting_dt]).to be_empty
    end
  end
end
