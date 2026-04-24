# frozen_string_literal: true

RSpec.shared_context "in-memory AR" do
  before(:all) do
    ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
    ActiveRecord::Schema.define do
      create_table :activities, force: true do |t|
        t.date :birth_d
        t.datetime :meeting_dt
        t.date :created_on
        t.datetime :updated_at
      end
    end

    Object.send(:remove_const, :Activity) if defined?(Activity)
    eval <<~RUBY, binding, __FILE__, __LINE__ + 1 # rubocop:disable Security/Eval
      class Activity < ActiveRecord::Base
        include SmarterDates::ActiveRecordIntegration
      end
    RUBY
  end

  after(:all) { Object.send(:remove_const, :Activity) if defined?(Activity) }
  let(:activity) { Activity.new }
end

RSpec.shared_context "AR with validator" do
  before(:all) do
    ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
    ActiveRecord::Schema.define do
      create_table :validated_activities, force: true do |t|
        t.date :birth_d
        t.datetime :meeting_dt
      end
    end

    Object.send(:remove_const, :ValidatedActivity) if defined?(ValidatedActivity)
    eval <<~RUBY, binding, __FILE__, __LINE__ + 1 # rubocop:disable Security/Eval
      class ValidatedActivity < ActiveRecord::Base
        include SmarterDates::ActiveRecordIntegration
        validates :birth_d, chronic_parsable: true
        validates :meeting_dt, chronic_parsable: { datetime: true }
      end
    RUBY
  end

  after(:all) { Object.send(:remove_const, :ValidatedActivity) if defined?(ValidatedActivity) }
  let(:record) { ValidatedActivity.new }
end
