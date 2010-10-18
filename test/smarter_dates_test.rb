require 'rubygems'
require 'test/unit'
require File.join(File.dirname(__FILE__),'..','lib','smarter_dates')

class Model
  attr_accessor :name
  attr_accessor :birth_d
  attr_accessor :meeting_dt
  attr_accessor :created_on
  attr_accessor :updated_at

  include SmarterDates
end

class SmarterDatesTest < Test::Unit::TestCase
  def setup
    @model = Model.new
  end

  def test_date_parsing
    now = Time.now
    last_week = now - 60 * 60 * 24 * 7
    yesterday = now - 60 * 60 * 24

    @model.name = "Paul Belt"
    @model.birth_d = "22 April 1976"
    @model.meeting_dt = "today"
    @model.created_on = "one week ago"
    @model.updated_at = "yesterday"

    assert_equal "Paul Belt", @model.name

    assert_equal 1976, @model.birth_d.year
    assert_equal 4, @model.birth_d.mon
    assert_equal 22, @model.birth_d.mday

    assert_equal now.year, @model.meeting_dt.year
    assert_equal now.month, @model.meeting_dt.mon
    assert_equal now.mday, @model.meeting_dt.mday

    assert_equal last_week.year, @model.created_on.year
    assert_equal last_week.month, @model.created_on.mon
    assert_equal last_week.day, @model.created_on.mday

    assert_equal yesterday.year, @model.updated_at.year
    assert_equal yesterday.month, @model.updated_at.mon
    assert_equal yesterday.day, @model.updated_at.mday
  end
end

