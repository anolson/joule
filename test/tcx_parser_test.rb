require File.dirname(__FILE__) + '/helper'

module Joule
  class TcxParserTest < Joule::TestCase
    include UnitsConversion

    def test_parse_with_power()
      xml = IO.read(TCX_FILE_WITH_POWER)
      tcx_parser = Joule::TCX::Parser.new(xml)
      workout = tcx_parser.parse(:calculate_marker_values => true)
      # 2009-11-29T17:29:07Z Sun Nov 29 17:29:07 UTC 2009
      
      assert_equal "11/29/09 17:29:07", workout.properties.date_time.strftime("%m/%d/%y %H:%M:%S")
      assert_equal 3410, workout.data_points.size 
      assert_equal 3409, workout.data_points.last.time
      assert_equal 3479, workout.data_points.last.time_with_pauses
      assert_equal 66426, workout.data_points.last.time_of_day     
    end

    def test_parse_with_calculate_maker_values
      xml = IO.read(TCX_FILE_WITH_POWER)
      tcx_parser = Joule::TCX::Parser.new(xml)
      workout = tcx_parser.parse(:calculate_marker_values => true)
      
      assert_equal 1, workout.markers.size 
      assert_equal 150, workout.markers.first.average_power.round
      assert_equal 66, workout.markers.first.average_cadence
      assert_equal 12.8, sprintf("%.1f", millimeters_to_miles(workout.markers.first.distance)).to_f
      assert_equal 13.5, sprintf("%.1f", millimeters_per_second_to_miles_per_hour(workout.markers.first.average_speed)).to_f
      assert_equal " 0:56:49", Time.at(workout.markers.first.duration_seconds).utc.strftime("%k:%M:%S")
      assert_equal 511, workout.markers.first.energy
    end
    
    def test_parse_without_calculate_maker_values
      xml = IO.read(TCX_FILE_WITH_POWER)
      tcx_parser = Joule::TCX::Parser.new(xml)
      workout = tcx_parser.parse(:calculate_marker_values => false)
      
      assert_equal 0, workout.markers.first.average_power
    end
    
    def test_parse_without_calculate_peak_power_values
      xml = IO.read(TCX_FILE_WITH_POWER)
      tcx_parser = Joule::TCX::Parser.new(xml)
      workout = tcx_parser.parse(:calculate_peak_power_values => false)
      
      assert_equal 0, workout.peak_powers.size
    end
    
    
    
    
    # 
    # def test_parse_with_power_and_multiple_laps()      
    #   xml = IO.read('files/2009-12-01-15-26-32.tcx')
    #   tcx_parser = TcxParser.new(xml)
    #   tcx_parser.parse  
    #   data_points = tcx_parser.data_points
    #   
    #   assert_equal 9619, data_points.size 
    # end

    # def test_parse_with_speed()
    #   xml = IO.read('files/activity_8755231.tcx')
    #   tcx_parser = TcxParser.new(xml)
    #   tcx_parser.parse  
    #   data_points = tcx_parser.data_points
    #   
    #   assert_equal 17734, data_points.size 
    # end


  end
end