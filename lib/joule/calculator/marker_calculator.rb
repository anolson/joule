module Joule
  module Calculator
    module MarkerCalculator
      
      def calculate_marker_averages(marker)
        marker.average_power = Joule::Calculator::PowerCalculator::average(
          self.data_points[marker.start..marker.end].collect() {|v| v.power})

        marker.average_speed = Joule::Calculator::PowerCalculator::average(
          self.data_points[marker.start..marker.end].collect() {|v| v.speed})

        marker.average_cadence = Joule::Calculator::PowerCalculator::average(
          self.data_points[marker.start..marker.end].collect() {|v| v.cadence})

        marker.average_heartrate = Joule::Calculator::PowerCalculator::average(
          self.data_points[marker.start..marker.end].collect() {|v| v.heartrate})
      end

      def calculate_marker_maximums(marker)
        marker.maximum_power = Joule::Calculator::PowerCalculator::maximum(
           self.data_points[marker.start..marker.end].collect() {|value| value.power})

         marker.maximum_speed = Joule::Calculator::PowerCalculator::maximum(
           self.data_points[marker.start..marker.end].collect() {|value| value.speed})

         marker.maximum_cadence = Joule::Calculator::PowerCalculator::maximum(
           self.data_points[marker.start..marker.end].collect() {|value| value.cadence})

         marker.maximum_heartrate = Joule::Calculator::PowerCalculator::maximum(
           self.data_points[marker.start..marker.end].collect() {|value| value.heartrate})
      end

      def calculate_marker_training_metrics(marker)
        marker.normalized_power = Joule::Calculator::PowerCalculator::normalized_power( 
          self.data_points[marker.start..marker.end].collect() {|value| value.power}, self.properties.record_interval)
      end
      
    end
  end
end