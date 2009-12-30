require File.dirname(__FILE__) + '/helper'

module Joule
  class TestUnitsConverter < Joule::TestCase
    include Joule::UnitsConversion
        
    def test_parse
      data = IO.read(IBIKE_FILE)
      ibike_parser = Joule::IBike::Parser.new(data)      
      ibike_parser.parse(:calculate_marker_values => true)
      
      assert_equal 1, ibike_parser.properties.record_interval
      assert_equal "09/14/08 16:41:52", ibike_parser.properties.date_time.strftime("%m/%d/%y %H:%M:%S")
      assert_equal "english", ibike_parser.properties.units
      assert_equal 31.56, ( millimeters_to_miles ibike_parser.data_points.last.distance ).round(2)
      assert_equal 212, ibike_parser.markers.first.average_power.round
      assert_equal 25.38, ( millimeters_per_second_to_miles_per_hour ibike_parser.markers.first.average_speed ).round(2)
      
    end
  end
end
