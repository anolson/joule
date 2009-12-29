class IBikeProperties
  ENGLISH_UNITS = "english"
  METRIC_UNITS = "metric"

  attr_accessor :version 
  attr_accessor :units 
  attr_accessor :date_time 
  attr_accessor :total_weight 
  attr_accessor :energy 
  attr_accessor :record_interval 
  attr_accessor :starting_elevation 
  attr_accessor :total_climbing 
  attr_accessor :wheel_size 
  attr_accessor :temperature 
  attr_accessor :starting_pressure 
  attr_accessor :wind_scaling 
  attr_accessor :riding_tilt 
  attr_accessor :calibration_weight 
  attr_accessor :cm 
  attr_accessor :cda 
  attr_accessor :crr
  
  def distance_units_are_english?
    self.units_are_english?
  end
  
  def distance_units_are_metric?
    self.units_are_metric?
  end
  
  def speed_units_are_english?
    self.units_are_english?
  end
  
  def distance_units_are_metric?
    self.units_are_metric?
  end
  
  def units_are_english?
    self.units.eql?(ENGLISH_UNITS)
  end
  
  def units_are_metric?
    self.units.eql?(METRIC_UNITS)
  end
  
end