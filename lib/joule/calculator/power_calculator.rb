module Joule
  module Calculator
    class PowerCalculator
      def self.average(values)
        values.average
      end

      def self.maximum(values)
        values.maximum
      end

      def self.total(values)
        values.sum
      end

      def self.peak_power(array, duration, size)
        average_maximum = array.average_maximum size
        peak_power = PeakPower.new(duration)
        peak_power.start = average_maximum[:start]
        peak_power.value = average_maximum[:value]
        peak_power
      end
    
      def self.training_stress_score(duration_seconds, normalized_power, threshold_power)
        if(threshold_power > 0)
          normalized_work = normalized_power * duration_seconds
          raw_training_stress_score = normalized_work * intensity_factor(normalized_power, threshold_power)
          (raw_training_stress_score/(threshold_power * 3600)) * 100
        end
      end

      def self.intensity_factor(normalized_power, threshold_power)
        if(threshold_power > 0)
          normalized_power/threshold_power
        end
      end
    
      def self.normalized_power(values, record_interval)
        thirty_second_record_count = 30 / record_interval
        thirty_second_rolling_power = Array.new
        if(values.length > thirty_second_record_count)
          values.slice(thirty_second_record_count..-1).each_slice(thirty_second_record_count) { |s|
            thirty_second_rolling_power << s.average ** 4
          }
          thirty_second_rolling_power.average ** 0.25
        else
          0
        end
      end
    end
  end
end