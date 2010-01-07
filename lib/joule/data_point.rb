module Joule
  class DataPoint
    include Joule::Hashable
    
    attr_accessor :altitude 
    attr_accessor :cadence
    attr_accessor :distance
    attr_accessor :heartrate
    attr_accessor :latitude
    attr_accessor :longitude
    attr_accessor :power
    attr_accessor :speed
    attr_accessor :time
    attr_accessor :time_of_day
    attr_accessor :time_with_pauses
    attr_accessor :torque 

    def initialize()
      @altitude = 0.0
      @cadence = 0
      @distance = 0.0
      @heartrate = 0
      @latitude = 0.0
      @longitude = 0.0
      @power = 0.0
      @speed = 0.0
      @time = 0
      @time_of_day = 0
      @time_with_pauses= 0
      @torque = 0.0
    end
  end  
end