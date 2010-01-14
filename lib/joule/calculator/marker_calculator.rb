module Joule
  module Calculator
    module MarkerCalculator
      
      def calculate_marker_averages(marker)
        marker.average_power = Joule::Calculator::PowerCalculator::average(
          @workout.data_points[marker.start..marker.end].collect() {|v| v.power})

        marker.average_speed = Joule::Calculator::PowerCalculator::average(
          @workout.data_points[marker.start..marker.end].collect() {|v| v.speed})

        marker.average_cadence = Joule::Calculator::PowerCalculator::average(
          @workout.data_points[marker.start..marker.end].collect() {|v| v.cadence})

        marker.average_heartrate = Joule::Calculator::PowerCalculator::average(
          @workout.data_points[marker.start..marker.end].collect() {|v| v.heartrate})
      end

      def calculate_marker_maximums(marker)
        marker.maximum_power = Joule::Calculator::PowerCalculator::maximum(
           @workout.data_points[marker.start..marker.end].collect() {|value| value.power})

         marker.maximum_speed = Joule::Calculator::PowerCalculator::maximum(
           @workout.data_points[marker.start..marker.end].collect() {|value| value.speed})

         marker.maximum_cadence = Joule::Calculator::PowerCalculator::maximum(
           @workout.data_points[marker.start..marker.end].collect() {|value| value.cadence})

         marker.maximum_heartrate = Joule::Calculator::PowerCalculator::maximum(
           @workout.data_points[marker.start..marker.end].collect() {|value| value.heartrate})
      end

      def calculate_marker_training_metrics(marker)
        marker.normalized_power = Joule::Calculator::PowerCalculator::normalized_power( 
          @workout.data_points[marker.start..marker.end].collect() {|value| value.power}, @workout.properties.record_interval)
      end
      
      
      def calculate_marker_totals(marker, index)
        if(index == 0)
          marker.distance = @workout.data_points.last.distance
          marker.duration_seconds = @workout.data_points.last.time
        else
          if(marker.start == 0)
            marker.distance = @workout.data_points[marker.end].distance - @workout.data_points[marker.start].distance
            marker.duration_seconds = @workout.data_points[marker.end].time - @workout.data_points[marker.start].time
          else
            marker.distance = @workout.data_points[marker.end].distance - @workout.data_points[marker.start - 1].distance
            marker.duration_seconds = @workout.data_points[marker.end].time - @workout.data_points[marker.start - 1].time
          end 
        end
        
        marker.energy = (marker.average_power.round * marker.duration_seconds)/1000        
      end
      
      def calculate_marker_values(options = {})
        @workout.markers.each_with_index { |marker, i|
          calculate_marker_averages marker      
          calculate_marker_maximums marker
          calculate_marker_training_metrics marker
          calculate_marker_totals marker, i  
        }
      end
      
    end
  end
end