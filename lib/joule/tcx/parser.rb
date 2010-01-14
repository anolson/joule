require 'nokogiri'
require 'time'

module Joule
  module TCX
    class Parser < Joule::Base::Parser

      def parse_workout()
        @total_record_count = 0
        parse_activity("Biking")
        create_workout_marker()
      end
      
      def parse_properties
        @properties = Joule::TCX::Properties.new
        @properties.record_interval = 1
      end

      private  
      def create_workout_marker
        if(@markers.size > 1)
          @markers << Marker.new(:start => 0, :end => @data_points.size - 1)
        end
      end
      

      def parse_activity(sport)
        document = Nokogiri::XML::Document.parse(@data)
        document.xpath("//xmlns:Activity[@Sport='#{sport}']").each do |activity|
          @properties.date_time = Time.parse(activity.at("./xmlns:Id").content)

          activity.children.each do |child|
            parse_lap(child) if child.name == "Lap"
          end

          calculate_speed if(!@has_native_speed)

        end
      end

      def parse_lap(lap_node)

        marker = Marker.new
                
        if @data_points.size > 0
          marker.start = @data_points.last.time + 1
        else
          marker.start= 0
        end

        lap_node.children.each do |child|
          marker.duration_seconds = child.content.to_i if child.name == "TotalTimeSeconds" 
          parse_track(child) if(child.name == "Track")
        end
        marker.end = @data_points.last.time
        @markers << marker
      end

      def parse_track(track)
        @trackpoint_count = 0
        track.children.each do |trackpoint|
          parse_trackpoint(trackpoint) if(trackpoint.name == "Trackpoint")

        end

      end

      def parse_trackpoint(trackpoint)
        data_point = DataPoint.new

        trackpoint.children.each do |data|
          parse_times(data, data_point) if(data.name == "Time")
          data_point.altitude = data.content.to_f if data.name == "AltitudeMeters"
          data_point.distance = (data.content.to_f * 1000) if data.name == "DistanceMeters"
          data_point.cadence = data.content.to_i if data.name == "Cadence"
          parse_heartrate(data, data_point) if data.name == "HeartRateBpm"
          parse_extensions(data, data_point) if data.name == "Extensions"
          parse_position(data, data_point) if data.name == "Position" 
        end
        @data_points << data_point
        @trackpoint_count = @trackpoint_count + 1
        @total_record_count = @total_record_count + 1
      end

      def parse_times(data, data_point)
        time_of_day =  Time.parse(data.content)
        data_point.time_of_day = (time_of_day.hour * 3600) + (time_of_day.min * 60) + time_of_day.sec
        data_point.time = @total_record_count * @properties.record_interval

        if(@trackpoint_count == 0)
          track_start_time = data_point.time_of_day
          @track_offset_in_seconds = track_start_time - @properties.start_time_in_seconds
        end
        data_point.time_with_pauses = (@trackpoint_count * @properties.record_interval) + @track_offset_in_seconds
      end

      def parse_heartrate(heartrate, data_point)
        heartrate.children.each do |child|
          data_point.heartrate = child.content.to_i if child.name == "Value"
        end
      end

      def parse_extensions(extensions, data_point)
        extensions.children.each do |extension|
          extension.children.each do |tpx|
            (data_point.speed = tpx.content.to_f; @has_native_speed = true;) if(tpx.name == "Speed")
            (data_point.power = tpx.content.to_f) if(tpx.name == "Watts")
          end 
        end  
      end

      def parse_position(position, data_point)
        position.children.each do |child|
          (data_point.latitude = child.content.to_f) if child.name == "LatitudeDegrees"
          (data_point.longitude = child.content.to_f) if child.name == "LongitudeDegrees"
        end
      end

      def calculate_speed
        @data_points.each_with_index { |v, i| 
          if(i == 0)
            delta = v.distance 
          else
            delta = v.distance - @data_points[i-1].distance
          end
          v.speed = delta / @properties.record_interval      
        }
      end
    end
    
  end
end