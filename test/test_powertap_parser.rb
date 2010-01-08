require File.dirname(__FILE__) + '/helper'

module Joule
  class TestPowertapParser < Joule::TestCase
    include Joule::UnitsConversion
        
    def test_parse
      data = IO.read(POWER_TAP_FILE)
      powertap_parser = Joule::PowerTap::Parser.new(data)      
      powertap_parser.parse(:calculate_marker_values => true)
      
      assert_equal 6, powertap_parser.markers.size
      assert_equal 138, powertap_parser.markers.first.average_power.round

      assert_equal 896, powertap_parser.markers.first.energy
      
      assert_equal 5.08, millimeters_to_miles(powertap_parser.markers[1].distance).round(2)
      assert_equal 4.46, millimeters_to_miles(powertap_parser.markers[2].distance).round(2)
      
      assert_equal 6499, powertap_parser.markers[0].duration_seconds
      assert_equal 945, powertap_parser.markers[1].duration_seconds
      assert_equal 896, powertap_parser.markers[2].duration_seconds
      
      #   assert_equal 346, training_file.peak_powers.first[:value].round
      
      

    end
  end
end



