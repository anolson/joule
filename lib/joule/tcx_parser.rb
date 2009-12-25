require 'nokogiri'
#require 'data_point'
#require 'tcx_properties'
#require 'lap'

module Joule

  class TcxParser

    attr_reader :data_points, :markers, :properties

    def initialize(xml = "")
      @xml = xml
      @data_points = Array.new
      @properties = TcxProperties.new
      @markers = Array.new
    end

    def parse
      @properties.record_interval = 1
      @record_count = 0
      parse_activity("Biking")
      calculate_marker_values()
      #calculate_record_interval()
      #calculate_data_point_times()
      #parse_markers()
      # @data_points.each do |data_point| 
      #       puts "Time : #{Time.at(data_point.time).utc.strftime("%k:%M:%S")}  -- #{Time.at(data_point.time_with_pauses).utc.strftime("%k:%M:%S")}  -- #{data_point.power}" 
      #     end
      # puts "Record count: #{@data_points.count-1}"
    end

    private
      def parse_activity(sport)
        document = Nokogiri::XML::Document.parse(@xml)
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
          
          @record_count = @record_count + 1  
        end
        @trackpoint_count = @trackpoint_count + 1
      end

      def parse_trackpoint(trackpoint)
        data_point = DataPoint.new
        
        trackpoint.children.each do |data|
          parse_times(data, data_point) if(data.name == "Time")
          data_point.altitude = data.content if data.name == "AltitudeMeters"
          data_point.distance = trackpoint.content if data.name == "DistanceMeters"
          data_point.cadence = trackpoint.content if data.name == "Cadence"
          parse_heartrate(data, data_point) if data.name == "HeartRateBpm"
          parse_extensions(data, data_point) if data.name == "Extensions"
          parse_position(data, data_point) if data.name == "Position" 
        end

        @data_points << data_point
      end


      def parse_times(data, data_point)
        time_of_day =  DateTime.parse(data.content)
        data_point.time_of_day = (time_of_day.hour * 3600) + (time_of_day.min * 60) + time_of_day.sec
        data_point.time = @record_count * @properties.record_interval

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

      # def parse_markers
      #   @laps.each do |lap|
      #     count=0
      #     @data_points.each do |data_point|
      #       if(lap.start_time < data_point.time_of_day)
      #         puts "Finding Marker Start: #{count-1} -- #{(count-1) + lap.duration_seconds.to_i} -- #{lap.duration_seconds.to_i/60}"
      #         break
      #       end
      #       count = count + 1
      #     end
      #   end
      #   
      # end


      def calculate_marker_values
        if(@markers.size > 1)
          @markers << Marker.new(:start => 0, :end => @data_points.size - 1)

        end

        # @laps.each_with_index { |marker, i|
        #   calculate_marker_averages marker      
        #   calculate_marker_maximums marker
        #   calculate_marker_training_metrics marker
        # 
        #   if i.eql?(0)
        #     marker.distance = @data_values.last.distance
        #     marker.
        #   else
        #     marker.distance = @data_values[marker.end + 1].distance - @data_values[marker.start].distance
        #   end
        # 
        #   marker.energy = (marker.avg_power.round * marker.duration_seconds)/1000
        # 
        # }
      end


      def calculate_data_point_times
        count = 0
        @data_points.each do |data_point|
          data_point.time = count * @properties.record_interval
          count = count + 1
        end
      end

      def calculate_record_interval()
        times = Array.new
        @data_points[1..30].each_slice(2) do |s| times <<  s[1].time_of_day.sec - s[0].time_of_day.sec end
        @properties.record_interval = times.average.round
      end
  end
end