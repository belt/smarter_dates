# frozen_string_literal: true

RSpec.describe SmarterDates::PlainIntegration do
  let(:klass) do
    Class.new do
      attr_accessor :birth_d, :meeting_dt, :created_on, :updated_at, :name
      include SmarterDates::PlainIntegration
    end
  end

  let(:obj) { klass.new }

  it "parses _d suffix to Date" do
    obj.birth_d = "22 April 1976"
    expect(obj.birth_d).to eq(Date.new(1976, 4, 22))
  end

  it "parses _on suffix to Date" do
    obj.created_on = "yesterday"
    expect(obj.created_on).to eq(Date.today - 1)
  end

  it "parses _dt suffix to DateTime" do
    obj.meeting_dt = "noon march 15 2026"
    expect(obj.meeting_dt).to be_a(DateTime)
  end

  it "parses _at suffix to DateTime" do
    obj.updated_at = "yesterday"
    expect(obj.updated_at).to be_a(DateTime)
  end

  it "leaves non-suffixed attributes alone" do
    obj.name = "Paul Belt"
    expect(obj.name).to eq("Paul Belt")
  end

  it "stores nil for unparseable input" do
    obj.birth_d = "32 April 1976"
    expect(obj.birth_d).to be_nil
  end

  describe "legacy include SmarterDates routes here" do
    let(:legacy_klass) do
      Class.new do
        attr_accessor :due_on
        include SmarterDates
      end
    end

    it "parses through PlainIntegration" do
      o = legacy_klass.new
      o.due_on = "next friday"
      expect(o.due_on).to be_a(Date)
    end
  end
end
