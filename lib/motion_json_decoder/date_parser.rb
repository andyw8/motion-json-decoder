module JSONDecoder
  class DateParser
    def initialize(format = "yyyy-MM-dd")
      @format = format
    end

    def parse(date_string)
      date_formatter = NSDateFormatter.alloc.init
      date_formatter.setDateFormat @format
      result = date_formatter.dateFromString date_string
      result or raise "Failed to parse date '#{date_string}' using format '#{format}'"
    end
  end
end
