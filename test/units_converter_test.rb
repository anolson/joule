require File.dirname(__FILE__) + '/helper'

module Joule
  class UnitsConverterTest < Joule::TestCase
    include Joule::UnitsConversion
        
    def test_miles_per_hour_to_millimeters_per_second
      speed = miles_per_hour_to_millimeters_per_second(100)
      assert_equal 44704, speed
    end
  
    def test_millimeters_per_second_to_miles_per_hour
      speed = millimeters_per_second_to_miles_per_hour(44704)
      assert_equal 100, speed
    end
  
    def test_kilometers_per_hour_to_millimeters_per_second
      speed = kilometers_per_hour_to_millimeters_per_second 100
      assert_equal 27778, speed.round
    end
  
    def test_millimeters_per_second_to_kilometers_per_hour
      speed = millimeters_per_second_to_kilometers_per_hour 27778
      assert_equal 100, speed.round
    end
    
    def test_miles_to_millimeters
      distance = miles_to_millimeters 2
      assert_equal 3218688, distance
    end
    
    def test_millimeters_to_miles
      distance = millimeters_to_miles 3218688
      assert_equal distance, 2
    end
    
    def test_kilometers_to_millimeters
      distance = kilometers_to_millimeters 2
      assert_equal 2000000, distance
    end
    
    def test_millimeters_to_kilometers
      distance = millimeters_to_kilometers 2000000
      assert_equal 2, distance
    end
  end
end