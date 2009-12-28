require 'nokogiri'

module Joule
  class TcxParser
    include MarkerCalculator
    include PeakPowerCalculator

    attr_reader :data_points, :markers, :properties, :peak_powers

    def initialize(string_or_io)
      @string_or_io = string_or_io
      @data_points = Array.new
      @properties = TcxProperties.new
      @markers = Array.new
      @peak_powers = Array.new
    end

    def parse(options = {})
      @properties.record_interval = 1
      @total_record_count = 0
      parse_activity("Biking")
      create_workout_marker()
      
      if(options[:calculate_marker_values])
        calculate_marker_values()
      end
      
      if(options[:calculate_peak_power_values])
        calculate_peak_power_values(:durations => options[:durations], :total_duration => @markers.first.duration_seconds)
      end
    end

    private
    
      def create_workout_marker
        if(@markers.size > 1)
          @markers << Marker.new(:start => 0, :end => @data_points.size - 1)
        end
      end
      
      
      def parse_activity(sport)
        document = Nokogiri::XML::Document.parse(@string_or_io)
        document.xpath("//xmlns:Activity[@Sport='#{sport}']").each do |activity|
          @properties.id = activity.at("./xmlns:Id").content

          activity.children.each do |child|
            parse_lap(child) if child.name == "Lap"

          end
        end
      end

      def parse_lap(lap_node)

        marker = Marker.new
        marker.start_time = DateTime.parse(lap_node.attribute("StartTime").content)

        if(@markers.size == 0)
          @properties.start_date_time = marker.start_time
        end
        
        if @data_points.size > 0
          marker.start = @data_points.last.time + 1
        else
          marker.start= 0
        end

        lap_node.children.each do |child|
          marker.duration_seconds = child.content.to_i if child.name == "TotalTimeSeconds" 
          # puts "Distance in meters: #{child.content}" if child.name == "DistanceMeters"
          # puts "Maximum Speed: #{child.content}" if child.name == "MaximumSpeed"
          # puts "Calories: #{child.content}" if child.name == "Calories"
          # puts "Intensity: #{child.content}" if child.name == "Intensity"
          # puts "Cadence: #{child.content}" if child.name == "Cadence"  
          # puts "Trigger Method: #{child.content}" if child.name == "TriggerMethod"  
          parse_track(child) if(child.name == "Track")
        end
        marker.end = @data_points.last.time
        @markers << marker
      end

      def parse_track(track)
        @trackpoint_count = 0
        track.children.each do |trackpoint|
          parse_trackpoint(trackpoint) if(trackpoint.name == "Trackpoint")
          @trackpoint_count = @trackpoint_count + 1
          @total_record_count = @total_record_count + 1  
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
      end


      def parse_times(data, data_point)
        time_of_day =  DateTime.parse(data.content)
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
            (data_point.speed = tpx.content.to_f) if(tpx.name == "Speed")
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

      def calculate_marker_values
        @markers.each_with_index { |marker, i|
          calculate_marker_averages marker      
          calculate_marker_maximums marker
          calculate_marker_training_metrics marker
        
          if i.eql?(0)
            marker.distance = @data_points.last.distance
          else
            marker.distance = @data_points[marker.end + 1].distance - @data_points[marker.start].distance
          end
        
          marker.duration_seconds = (marker.end - marker.start + 1) * @properties.record_interval
          marker.energy = (marker.average_power.round * marker.duration_seconds)/1000
        
        }
      end
  end
end