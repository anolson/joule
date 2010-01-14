module Joule
  class Workout
    # An Array of DataPoint objects.  Contains all the data points. 
    attr_accessor :data_points
    
    # An Array of Marker objects.  The first marker always represents the entire 
    # set of data.    
    attr_accessor :markers
    
    # An Array of Hash objects representing the peak powers for a give duration (5
    # second, 5 minute, 20  minute, etc).  This is also sometimes referred to the
    # mean maximal power. Peak power calculations can add a significant amount 
    # of time to parsing, so you can perform these later on if you want to with 
    # the Joule::Calculator::PeakPowerCalculator.
    attr_accessor :peak_powers

    # The properties object represents device properties specific to the data
    # being parsed.  
    attr_accessor :properties
    
    def initialize()
      @data_points = Array.new
      @markers = Array.new
      @peak_powers = Array.new 
      @properties = Object.new     
    end
    
  end
end