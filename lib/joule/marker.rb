class Marker
  attr_accessor :active
  attr_accessor :average_cadence
  attr_accessor :average_heartrate
  attr_accessor :average_power
  attr_accessor :average_power_to_weight
  attr_accessor :average_speed
  attr_accessor :comment
  attr_accessor :duration_seconds
  attr_accessor :distance
  attr_accessor :end
  attr_accessor :energy
  attr_accessor :intensity_factor
  attr_accessor :maximum_cadence
  attr_accessor :maximum_heartrate
  attr_accessor :maximum_power
  attr_accessor :maximum_power_to_weight
  attr_accessor :maximum_speed 
  attr_accessor :normalized_power 
  attr_accessor :start
  attr_accessor :start_time
  attr_accessor :training_stress_score 
  
  
  def initialize(options = {})
    @active = true
    @average_cadence = 0
    @average_heartrate = 0
    @average_power = 0.0
    @average_power_to_weight = 0.0
    @average_speed = 0.0
    @comment = ""
    @duration_seconds = 0
    @distance = 0.0
    @end = options[:end]
    @energy = 0
    @intensity_factor = 0
    @maximum_cadence = 0
    @maximum_heartrate = 0
    @maximum_power = 0.0
    @maximum_power_to_weight = 0.0
    @maximum_speed = 0.0
    @normalized_power = 0
    @start = options[:start]
    @training_stress_score = 0.0
    
  end
  
  def start_time_in_seconds
    (@start_time.hour * 3600) + (@start_time.min * 60) + @start_time.sec
  end
end

