
module Joule
  module MarkerCalculator
    def calculate_marker_averages(marker)
      marker.avg_power = Joule::PowerCalculator::average(
        self.data_points[marker.start..marker.end].collect() {|v| v.power}).round
      
      marker.avg_speed = Joule::PowerCalculator::average(
        self.data_points[marker.start..marker.end].collect() {|v| v.speed})
      
      marker.avg_cadence = Joule::PowerCalculator::average(
        self.data_points[marker.start..marker.end].collect() {|v| v.cadence})
      
      marker.avg_heartrate = Joule::PowerCalculator::average(
        self.data_points[marker.start..marker.end].collect() {|v| v.heartrate})
    end

    def calculate_marker_maximums(marker)
      marker.max_power = Joule::PowerCalculator::maximum(
         self.data_points[marker.start..marker.end].collect() {|value| value.power})
       
       marker.max_speed = Joule::PowerCalculator::maximum(
         self.data_points[marker.start..marker.end].collect() {|value| value.speed})
       
       marker.max_cadence = Joule::PowerCalculator::maximum(
         self.data_points[marker.start..marker.end].collect() {|value| value.cadence})
       
       marker.max_heartrate = Joule::PowerCalculator::maximum(
         self.data_points[marker.start..marker.end].collect() {|value| value.heartrate})
     end

    def calculate_marker_training_metrics(marker)
      marker.normalized_power = Joule::PowerCalculator::normalized_power( 
        self.data_points[marker.start..marker.end].collect() {|value| value.power}, self.properties.record_interval)
    end
  end
end