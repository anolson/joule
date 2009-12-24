class Marker
  attr_accessor :start_time, :duration_seconds, :start, :end
  
  def initialize(options = {})
    @start = options[:start]
    @end = options[:end]
  end
  
  
  def start_time_in_seconds
    (@start_time.hour * 3600) + (@start_time.min * 60) + @start_time.sec
  end
end

