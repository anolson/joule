require File.dirname(__FILE__) + '/helper'

module Joule
  class SrmParserTest < Joule::TestCase
    include Joule::UnitsConversion
        
    def test_parse
      data = IO.read(SRM_FILE)
      srm_parser = Joule::SRM::Parser.new(data)      
      workout = srm_parser.parse(:calculate_marker_values => true, :calculate_peak_power_values => true, :durations => [5, 60])
      
      puts workout.properties.date_time.class
      # assert_equal 1812, srm_parser.properties.record_count
      # assert_equal 3624, srm_parser.markers.first.duration_seconds
      
      assert_equal 3, workout.markers.size

      assert_equal 1200, workout.markers[1].duration_seconds
      assert_equal 1204, workout.markers[2].duration_seconds
      
      assert_equal 7.12, millimeters_to_miles(workout.markers[1].distance).round(2)
      assert_equal 7.12, millimeters_to_miles(workout.markers[2].distance).round(2)
      
      assert_equal 218.9, workout.markers[0].average_power.round(1)
      assert_equal 280.5, workout.markers[1].average_power.round(1)
      assert_equal 281.6, workout.markers[2].average_power.round(1)
      # assert_equal 314, training_file.peak_powers.first[:value].round
      # assert_equal 722, training_file.peak_powers.first[:start]
    end
  end
end
