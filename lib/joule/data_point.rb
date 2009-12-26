module Joule
  class DataPoint
    attr_accessor :altitude, :cadence, :distance, :heartrate, :latitude, :longitude, :power, :speed, :time, :time_of_day, :time_with_pauses   

    def initialize()
      @time_of_day = 0
      @time = 0
      @time_with_pauses=0
      @power = 0.0
      @speed = 0.0
      @cadence = 0
      @distance = 0.0
      @altitude = 0.0
      @latitude = 0.0
      @longitude = 0.0
      @heartrate = 0
    end
  end  
end