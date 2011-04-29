require File.dirname(__FILE__) + '/helper'

module Joule
  class PowerCalculatorTest < Joule::TestCase
  
    def setup
      @power_values = Array.new
      File.open(RAW_POWER_VALUES_FILE, 'r') do |io|
        while(line = io.gets)
          @power_values << line.to_f
        end
      end    
    end
    
    def test_average
      average_power = Joule::Calculator::PowerCalculator.average(@power_values)
      assert_equal 150, average_power.round
    end
    
    def test_maximum
      maximum_power = Joule::Calculator::PowerCalculator.maximum(@power_values)
      assert_equal 359, maximum_power.round
    end
    
    def test_peak_power
      peak_power = Joule::Calculator::PowerCalculator.peak_power(@power_values, 1200, 1200)
      assert_equal 170, peak_power.value.to_i
    end
    
    def test_training_stress_score
      tss = Joule::Calculator::PowerCalculator.training_stress_score(@power_values.size, get_normalized_power, 200)
      assert_equal 65.07, tss.round(2)
    end
    
    def test_intensity_factor
      assert_equal 0.83, get_intensity_factor.round(2)
    end
    
    def test_normalized_power
      assert_equal 165.77, get_normalized_power.round(2)
    end
    
    def get_normalized_power
      Joule::Calculator::PowerCalculator.normalized_power(@power_values, 1)
    end
    
    def get_intensity_factor
      Joule::Calculator::PowerCalculator.intensity_factor(get_normalized_power, 200)
    end
    
  end
end