require 'spec_helper'

module SmarterDates
  class Activity < ActiveRecord::Base
    include SmarterDates
    validates :birth_d, presence: true
    validates :meeting_dt, presence: true
    validates :created_on, presence: true
    validates :updated_at, presence: true
  end
end

describe SmarterDates::Activity do
  before :all do
    @valid_inputs = [
      'yesterday', '12:55 pm', 'two and a half years', 'friday morning',
      'friday afternoon', 'april 22 1976', 'Thursday', 'noon march 15',
      'two thousand thirteen', 'july 4th', 'Mon Apr 22 17:00:00 PDT 2013',
      '27 Oct 2006 0730', '1/13', '13/9', '05/06', '5/6 6pm',
      '13th of this month', 'December 31st midnight', '2013-07',
      'december 31st 2013 midnight', '8th month next year',
      'third thursday in nov', 'last weekend', 'this weekend', 'this day',
      'tomorrow', 'last mon', 'in 10 minutes', '8 weekends ago',
      '2 months from now' ]
    @invalid_inputs = [ 'invalid input' ]
  end

  context 'validations' do
    subject { @valid_inputs }

    it 'should many variations of common-language inputs' do
      subject.each do |text|
        text.to_chronic_date
        text.to_chronic_datetime
      end
    end
  end

  context 'valid datetime parsing' do
    subject { @valid_inputs }

    it 'should many variations of common-language inputs' do
      subject.each do |text|
        obj = SmarterDates::Activity.new
        obj.birth_d = text
        obj.meeting_dt = text
        obj.created_on = text
        obj.updated_at = text
        obj.should be_valid
      end
    end
  end

  context 'invalid datetime parsing' do
    subject { @invalid_inputs }

    it 'should raise errors' do
      subject.each do |text|
        obj = SmarterDates::Activity.new

        props = [:birth_d, :meeting_dt, :created_on, :updated_at]
        props.each do |prop|
          obj.send("#{prop}=".to_sym, text)
          obj.send(prop).should be_nil
        end
        obj.should_not be_valid
        obj.errors.count.should be(props.count)
      end
    end
  end
end
