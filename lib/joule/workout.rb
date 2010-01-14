module Joule
  class Workout
    #   An Array of DataPoint objects.  Contains all the data points from a file. 
    attr_accessor :data_points
    
    #   An Array of Marker objects.  The first marker always represents the entire 
    #   file.  Marker averages, maximums, etc are only calculated, if the option 
    #   :calculate_markers_values => true is passed to parse().    
    attr_accessor :markers
    
    #   An Array of Hash objects representing the peak powers for a give duration (5
    #   second, 5 minute, 20  minute, etc).  This is also sometimes referred to the
    #   mean maximal power.  Peak powers are only available, if the options
    #   :calculate_peak_power_values => true and :durations are passed to parse().  
    #   Peak power calculations can add a significant amount of time to parsing, so  
    #   you can perform these later on if you want to with the 
    #   Joule::Calculator::PeakPowerCalculator.
    attr_accessor :peak_powers

    attr_accessor :properties
    
    def initialize()
      @data_points = Array.new
      @markers = Array.new
      @peak_powers = Array.new 
      @properties = Object.new     
    end
    
  end
end