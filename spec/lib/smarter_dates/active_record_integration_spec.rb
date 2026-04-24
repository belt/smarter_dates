# frozen_string_literal: true

RSpec.describe SmarterDates::ActiveRecordIntegration do
  include_context "in-memory AR"

  describe "writers" do
    it "parses _d suffix to Date" do
      activity.birth_d = "22 April 1976"
      expect(activity.birth_d).to eq(Date.new(1976, 4, 22))
    end

    it "parses _on suffix to Date" do
      activity.created_on = "2026-01-15"
      expect(activity.created_on).to eq(Date.new(2026, 1, 15))
    end

    it "parses _dt suffix to DateTime" do
      activity.meeting_dt = "2026-01-15T12:00:00Z"
      expect(activity.meeting_dt).to be_a(::DateTime).or be_a(::Time).or be_a(::ActiveSupport::TimeWithZone)
    end

    it "parses _at suffix to DateTime" do
      activity.updated_at = "noon january 15 2026"
      expect(activity.updated_at).not_to be_nil
    end

    it "stores nil for unparseable input" do
      activity.birth_d = "32 April 1976"
      expect(activity.birth_d).to be_nil
    end

    it "stores nil for nil input" do
      activity.birth_d = nil
      expect(activity.birth_d).to be_nil
    end
  end

  describe "natural-language" do
    it "parses 'yesterday' for _d" do
      activity.birth_d = "yesterday"
      expect(activity.birth_d).to eq(Date.today - 1)
    end

    it "parses 'one week ago' for _on" do
      activity.created_on = "one week ago"
      expect(activity.created_on).to eq(Date.today - 7)
    end
  end

  describe "legacy include SmarterDates" do
    before do
      Object.send(:remove_const, :LegacyActivity) if defined?(LegacyActivity)
      stub_const("LegacyActivity", Class.new(ActiveRecord::Base) {
        self.table_name = "activities"
        include SmarterDates
      })
    end

    it "still routes through ActiveRecordIntegration" do
      a = LegacyActivity.new
      a.birth_d = "yesterday"
      expect(a.birth_d).to eq(Date.today - 1)
    end
  end
end
