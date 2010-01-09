require 'fastercsv'

module Joule
  module CSV
    class Parser < Joule::Base::Parser
      include Joule::UnitsConversion

      def parse_workout()
        parse_markers
        parse_data_points
      end
      
      def get_parser
        header = FasterCSV.parse(@data).shift
        if header[0].to_s.downcase.eql?("ibike")
          return IbikeFileParser.new(data)
        else
          return PowertapFileParser.new(data)
        end
      end

      protected
      def create_workout_marker(records)
        Marker.new(:start => 0, :end => records.size - 1, :comment => "")
      end

    end
  end
end
