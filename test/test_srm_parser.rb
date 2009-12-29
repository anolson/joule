require File.dirname(__FILE__) + '/helper'

module Joule
  class TestSrmParser < Joule::TestCase
    include Joule::UnitsConversion
        
    def test_parse
      data = IO.read(SRM_FILE)
      ibike_parser = SrmParser.new(data)      
      ibike_parser.parse(:calculate_marker_values => true)
      
      # assert_equal 1812, training_file.powermeter_properties.record_count
      # assert_equal 3624, training_file.markers.first.duration_seconds
      # assert_equal 280, training_file.markers[1].avg_power.round
      # assert_equal 276, training_file.markers[2].avg_power.round
      # assert_equal 314, training_file.peak_powers.first[:value].round
      # assert_equal 722, training_file.peak_powers.first[:start]
    end
  end
end
