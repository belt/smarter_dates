module SmarterDates
require 'chronic'

def self.included( klass ) # :nodoc:
  dt_attributes = []
  db_migrated = true
  if defined?(Rails)
    begin
      dt_attributes.concat(klass.column_names.select{|k|k.match(/_(?:at|on|dt|d)$/)})
      Rails.logger.debug(RuntimeError,"unused include - #{klass.class.to_s} does not have any attributes ending in _at, _on, _dt, or _d") if db_migrated && dt_attributes.empty?
    rescue ActiveRecord::StatementInvalid => e
      db_migrated = false
    rescue => e
      Rails.logger.debug(e.inspect)
      db_migrated = false
    end
  else
    dt_attributes.concat(klass.instance_methods.select{|k|k.match(/_(?:at|on|dt|d)$/)})
  end

  # :call-seq:
  #   _on(string)
  #   _at(string)
  #   _dt(string)
  #   _d(string)
  #
  # Any attribute ending in _at, _on, _dt, or _d are parsed by Chronic.parse
  # (for flexibility).  Values are passed as is to Chronic.parse()
  #
  # == Arguments
  # <tt>string</tt>:: A string

  dt_attributes.each do |k|
    parse = Proc.new do |val|
      begin
        dt = Chronic.parse(val.to_s(:db))
      rescue
        dt = Chronic.parse(val.to_s)
      rescue
        dt = DateTime.parse(val)
      rescue
        dt = Date.parse(val)
      rescue
        dt = val
      end

      if respond_to?(:write_attribute)
        write_attribute(k,dt)
      else
        instance_variable_set(:"@#{k}",dt)
      end
    end
    klass.send(:define_method, "#{k}=".to_sym, &parse)
  end
end

# /module
end

