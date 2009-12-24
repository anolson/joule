module Joule
  class TcxProperties
    attr_accessor :id, :record_interval, :start_date_time

    def start_time_in_seconds
      (@start_date_time.hour * 3600) + (@start_date_time.min * 60) + @start_date_time.sec
    end

  end  
end