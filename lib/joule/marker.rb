class Marker
  attr_accessor :active
  attr_accessor :avg_cadence
  attr_accessor :avg_heartrate
  attr_accessor :avg_power
  attr_accessor :average_power_to_weight
  attr_accessor :avg_speed
  attr_accessor :comment
  attr_accessor :duration_seconds
  attr_accessor :distance
  attr_accessor :end
  attr_accessor :energy
  attr_accessor :intensitry_factor
  attr_accessor :max_cadence
  attr_accessor :max_heartrate
  attr_accessor :max_power
  attr_accessor :maximum_power_to_weight
  attr_accessor :max_speed 
  attr_accessor :normalized_power 
  attr_accessor :start
  attr_accessor :start_time
  attr_accessor :training_intensity
  
  def initialize(options = {})
    @start = options[:start]
    @end = options[:end]
  end
  
  def start_time_in_seconds
    (@start_time.hour * 3600) + (@start_time.min * 60) + @start_time.sec
  end
end

