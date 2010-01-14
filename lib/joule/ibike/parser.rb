module Joule
  module IBike
    class Parser < Joule::CSV::Parser
      IBIKE = '.csv'
      SPEED = 0
      WINDSPEED = 1
      POWER = 2
      DISTANCE = 3
      CADENCE = 4
      HEARTRATE = 5
      ELEVATION = 6
      SLOPE = 7
      DFPM_POWER = 11
      LATITUDE = 12
      LONGITUDE = 13
      TIMESTAMP = 14

      def parse_properties()
        records = FasterCSV.parse(@data)
        header = records.shift

        @workout.properties = Joule::IBike::Properties.new
        @workout.properties.version=header[1]
        @workout.properties.units=header[2]
        header = records.shift
        @workout.properties.date_time = Time.mktime(header[0].to_i, header[1].to_i, header[2].to_i, header[3].to_i, header[4].to_i, header[5].to_i)
        records.shift
        header = records.shift
        @workout.properties.total_weight = header[0]
        @workout.properties.energy = header[1]
        @workout.properties.record_interval = header[4].to_i
        @workout.properties.starting_elevation = header[5]
        @workout.properties.total_climbing = header[6]
        @workout.properties.wheel_size = header[7]
        @workout.properties.temperature = header[8]
        @workout.properties.starting_pressure = header[9]
        @workout.properties.wind_scaling = header[10]
        @workout.properties.riding_tilt = header[11]
        @workout.properties.calibration_weight = header[12]
        @workout.properties.cm = header[13]
        @workout.properties.cda = header[14]
        @workout.properties.crr = header[15]
      end

      def parse_data_points()
        records = FasterCSV.parse(@data).slice(5..-1)
        records.each_with_index { |record, index|
          data_point  = DataPoint.new
          data_point.time  = index * @workout.properties.record_interval
          data_point.speed = convert_speed(record[SPEED].to_f)
          data_point.power = record[POWER].to_f
          data_point.distance = convert_distance(record[DISTANCE].to_f)
          data_point.cadence = record[CADENCE].to_i
          data_point.heartrate = record[HEARTRATE].to_i
          @workout.data_points << data_point 
        }
      end

      def parse_markers
        records = FasterCSV.parse(@data).slice(5..-1)
        @workout.markers << create_workout_marker(records)
      end

    end
  end
end