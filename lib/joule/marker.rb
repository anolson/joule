class Marker
  attr_accessor :active, :avg_cadence, :avg_heartrate, :avg_power, :average_power_to_weight, :avg_speed, :comment, 
  :duration_seconds, :distance, :end, :energy, :intensitry_factor, :max_cadence, :max_heartrate, :max_power, 
  :maximum_power_to_weight, :max_speed, :normalized_power, :start, :start_time, :training_intensity, :end
  
  def initialize(options = {})
    @start = options[:start]
    @end = options[:end]
  end
  
  def start_time_in_seconds
    (@start_time.hour * 3600) + (@start_time.min * 60) + @start_time.sec
  end
end

