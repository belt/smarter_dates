require 'smarter_dates/version'
require 'chronic'

module SmarterDates
  def self.included(klass) # :nodoc:
    attr_accessor :dt_attributes

    @dt_attributes = []
    db_migrated = true
    if defined?(Rails)
      begin
        @dt_attributes.concat(klass.column_names.select { |k| k.match(/_(?:at|on|dt|d)$/) })
        Rails.logger.debug(RuntimeError, "unused include - #{klass.class.to_s} does not have any attributes ending in _at, _on, _dt, or _d") if db_migrated && @dt_attributes.empty?
      rescue ActiveRecord::StatementInvalid => _
      rescue => err
        Rails.logger.debug(err.inspect)
      end
    else
      @dt_attributes.concat(klass.instance_methods.select { |k| k.match(/_(?:at|on|dt|d)$/) })
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

    @dt_attributes.each do |k|
      parse = Proc.new do |val|
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
          if dt && k.match(/_(?:on|d)$/)
            self[k] = dt.to_date
          elsif dt
            self[k] = dt.to_datetime
          else
            self[k] = dt
          end
        else
          instance_variable_set(:"@#{k}", dt)
        end
      end
      klass.send(:define_method, "#{k}=".to_sym, &parse)
    end
  end
end

