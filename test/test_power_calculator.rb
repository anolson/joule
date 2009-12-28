require File.dirname(__FILE__) + '/helper'

module Joule
  class TestTcxParser < Joule::TestCase
  
    def setup
      @power_values = Array.new
      File.open(RAW_POWER_VALUES_FILENAME, 'r') do |io|
        while(line = io.gets)
          @power_values << line.to_f
        end
      end    
    end
    
    def test_average
      average_power = Joule::PowerCalculator.average(@power_values)
      assert_equal 150, average_power.round
    end
    
    def test_maximum
      maximum_power = Joule::PowerCalculator.maximum(@power_values)
      assert_equal 359, maximum_power.round
    end
    
    def test_peak_power
      peak_power = Joule::PowerCalculator.peak_power(@power_values, 1200)
      assert_equal 170, peak_power[:value].to_i
    end
    
    def test_training_stress_score
      assert true
    end
    
    def test_intensity_factor
      assert true
    end
    
    def test_normalized_power
      assert true
    end
    
  end
end