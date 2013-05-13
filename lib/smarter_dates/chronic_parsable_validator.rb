# validates attributes are parsable by the chronic gem
class ChronicParsableValidator < ActiveModel::EachValidator

  # == Creation
  # To use this Validator, initialize it as any other validator
  #
  #   class ExampleValidator < ActiveRecord::Base
  #     validates :attr1, :chronic_parsable => true
  #   end

  def initialize(*args) # :nodoc:
    @errors = []
    super(*args)
  end

  # :call-seq:
  # validate_each :record, :attribute, :value
  #
  # <tt>:record</tt>:: AR instance
  # <tt>:attribute</tt>:: symbol for attribute
  # <tt>:value</tt>:: value to check validity

  def validate_each(record, attribute, value = "") #:nodoc:
    @value = value
    record.errors[attribute] << 'not a valid Date or DateTime' unless is_valid?
  end

  # :call-seq:
  # is_valid?
  #
  # alias for :is_valid_datetime?

  def is_valid?
    is_valid_datetime?
  end

  # :call-seq:
  # is_valid_datetime?
  #
  # returns true if the string is parsable by chronic

  def is_valid_datetime?
    Chronic.parse(@value.respond_to?(:to_date) ? @value.to_date : @value.to_s)
  end

end

