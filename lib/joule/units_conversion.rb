module Joule
  module UnitsConversion
    def convert_speed(speed)
      #convert to mm/s
      if self.properties.speed_units_are_english?
        miles_per_hour_to_millimeters_per_second speed
      else
        kilometers_per_hour_to_millimeters_per_second speed
      end
    end

    def convert_distance(distance)
      #convert distance to mm
      if self.properties.distance_units_are_english?
        miles_to_millimeters distance
      else
        kilometers_to_millimeters distance
      end
    end

    def miles_per_hour_to_millimeters_per_second(speed)
      speed * 447.04 
    end

    def millimeters_per_second_to_miles_per_hour(speed)
      speed / 447.04 
    end

    def kilometers_per_hour_to_millimeters_per_second(speed)
      speed * 277.78 
    end

    def millimeters_per_second_to_kilometers_per_hour(speed)
      speed / 277.78 
    end

    def miles_to_millimeters(distance)
      distance * 1609344
    end

    def millimeters_to_miles(distance)
      distance / 1609344
    end

    def kilometers_to_millimeters(distance)
      distance * 1000000
    end

    def millimeters_to_kilometers(distance)
      distance / 1000000
    end

  end  
end

