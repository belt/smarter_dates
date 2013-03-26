# provide natural-language date / datetime parsing to strings
class String
  # :call-seq:
  # to_datetime
  #
  # Parses a string into a DateTime object using the Chronic gem if available.
  # If not, try parsing the string using :parse_with_builtins
  # raise an error if the string fails to parse

  def to_datetime
    begin
      if defined?(Chronic)
        dt = parse_with_chronic
      else
        dt = parse_with_builtins
      end
    end

    raise RuntimeError, "#{dt.inspect} unparsable Date/DateTime" unless dt

    dt.to_datetime
  end

  # :call-seq:
  # to_date
  #
  # Parses a string into a Date object using the same methods as .to_datetime

  def to_date
    to_datetime.to_date
  end

  # :call-seq:
  # to_time
  #
  # Parses a string into a Time object using the same methods as .to_datetime

  def to_time
    to_datetime.to_time
  end

  protected

  # :call-seq:
  # parse_with_chronic
  #
  # attempt to parse a string with Chronic

  def parse_with_chronic
    Chronic.time_class = Time.zone
    Chronic.parse(self)
  end

  # :call-seq:
  # parse_with_builtins
  #
  # attempt to parse a string with DateTime
  # failing that, attempt to parse a string with Date

  def parse_with_builtins
    begin
      return DateTime.parse(self)
    rescue
      return Date.parse(self)
    end
  end
end

