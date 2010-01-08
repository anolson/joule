require 'fastercsv'

module Joule
  module CSV
    class Parser
      include Joule::Calculator::MarkerCalculator
      include Joule::Calculator::PeakPowerCalculator
      include Joule::UnitsConversion

      attr_reader :properties, :markers, :data_points, :peak_powers


      def initialize(data)
        @data = data
        @markers = Array.new
        @data_points = Array.new
        @peak_powers = Array.new
      end

      def get_parser
        header = FasterCSV.parse(@data).shift
        if header[0].to_s.downcase.eql?("ibike")
          return IbikeFileParser.new(data)
        else
          return PowertapFileParser.new(data)
        end
      end

      def parse(options = {})
        parse_properties
        parse_markers
        parse_data_points

        if(options[:calculate_marker_values])
          calculate_marker_values()
        end

        if(options[:calculate_peak_power_values])
          calculate_peak_power_values(:durations => options[:durations], :total_duration => @markers.first.duration_seconds)
        end

      end

      protected
      def create_workout_marker(records)
        Marker.new(:start => 0, :end => records.size - 1, :comment => "")
      end

    end
  end
end
