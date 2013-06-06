require 'test/unit'
require 'rails'
require 'active_record'

if $LOAD_PATH.include?(File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib')))
  require 'smarter_dates'
else
  raise RuntimeError, "Try ruby -Ilib test/#{File.basename(__FILE__)}"
end

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Schema.define(version: 1) do
  create_table :models do |t|
    t.string :name
    t.date :created_on
  end
end

class Model < ActiveRecord::Base
  include SmarterDates
  attr_accessible :name, :created_on
  validates :created_on, chronic_parsable: true
end

class ChronicParsableValidatorTest < Test::Unit::TestCase
  def setup
    @model = Model.new
  end

  def test_parsing_validation
    @model.name = 'Paul Belt'
    valid_dates = ['22 April 1976', 'today', 'one week ago', 'yesterday']
    valid_dates.each do |date|
      @model.created_on = date
      assert @model.valid?
    end
    invalid_dates = ['safdsafds', '55 April 1976', '$%$@#$@', "", nil]
    invalid_dates.each do |date|
      @model.created_on = date
      assert !@model.valid?
      assert_match('not a valid Date or DateTime', @model.errors[:created_on][0])
    end
  end
end

