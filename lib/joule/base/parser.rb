module Joule
  module Base
    class Parser
      include Joule::Calculator::MarkerCalculator
      include Joule::Calculator::PeakPowerCalculator
      
      attr_reader :properties, :markers, :data_points, :peak_powers

      def initialize(data)
        @data = data  
        @data_points = Array.new
        @markers = Array.new
        @peak_powers = Array.new
      end

      def parse(options = {})

        parse_properties
        parse_workout
        
        if(options[:calculate_marker_values])
          calculate_marker_values()
        end

        if(options[:calculate_peak_power_values])
          calculate_peak_power_values(:durations => options[:durations], :total_duration => @markers.first.duration_seconds)
        end
        
      end
      
      def parse_workout
        raise NotImplementedError
      end

      def parse_properties
        raise NotImplementedError
      end
    end    
    
  end
end
