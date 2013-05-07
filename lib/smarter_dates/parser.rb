require 'smarter_dates/version'
require 'chronic'

module SmarterDates
  def self.included(klass) # :nodoc:
    dt_attributes(klass).each do |meth|
      parse = convert_to_dt(meth)
      klass.send(:define_method, "#{meth}=".to_sym, &parse)
    end
  end

  # :call-seq:
  # Module.convert_to_dt object
  #
  # attempts to convert using Chronic, DateTime and-or Date, whichever works first
  # else simply yield the value

  def self.convert_to_dt(convert_me)
    Proc.new do |val|
      begin
        dt = Chronic.parse(val.to_s)
      rescue
        dt = DateTime.parse(val.to_s)
      rescue
        dt = Date.parse(val)
      rescue
        dt = val
      end
      if defined?(Rails)
        set_rails_dt_attributes!(convert_me, dt)
      else
        instance_variable_set(:"@#{convert_me}", dt)
      end
    end
  end

  private

  # :call-seq:
  # Module.dt_attributes Klass
  #
  # Any attribute ending in _at, _on, _dt, or _d are parsed by Chronic.parse
  # (for flexibility).  Values are passed as is to Chronic.parse()
  #
  # == Arguments
  # <tt>string</tt>:: A string

  def self.dt_attributes(klass)
    @dt_attributes ||= []
    if defined?(Rails)
      @dt_attributes.concat(rails_dt_attributes(klass))
    else
      @dt_attributes.concat(klass.instance_methods.select { |meth| meth.match(/_(?:at|on|dt|d)$/) })
    end
    @dt_attributes.uniq || []
  end

  def self.connected? # :nodoc:
    ActiveRecord::Base.connected?
  end

  def self.migrated? # :nodoc:
    return unless connected?
    ActiveRecord::Base.connection.table_exists? 'schema'
  end

  # :call-seq:
  # Module.rails_dt_attributes Klass
  #
  # Any attribute ending in _at, _on, _dt, or _d are parsed by Chronic.parse
  # (for flexibility).  Values are passed as is to Chronic.parse()
  #
  # == Arguments
  # <tt>string</tt>:: A string

  def self.rails_dt_attributes(klass)
    logger = Rails.logger
    dt_attrs = klass.column_names.select { |meth| meth.match(/_(?:at|on|dt|d)$/) }
    logger.debug(RuntimeError, "unused include - #{klass.class.to_s} does not have any attributes ending in _at, _on, _dt, or _d") if migrated? && dt_attrs.empty?
    dt_attrs.uniq || []
  end

  # :call-seq:
  # Module.set_rails_dt_attributes! attribute, value
  #
  # set attribute ending in _at, _on, _dt, or _d to date datetime
  #
  # == Arguments
  # <tt>attribute</tt>:: attribute to set
  # <tt>value</tt>:: a value

  def set_rails_dt_attributes!(meth,dt)
    if meth.match(/_(?:on|d)$/)
      self[meth] = dt.try(:to_date)
    elsif dt
      self[meth] = dt.try(:to_datetime)
    else
      self[meth] = dt
    end
  end
end

