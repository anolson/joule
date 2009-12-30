require 'kconv'

module Joule
  class SrmParser
    include MarkerCalculator
    include PeakPowerCalculator
    SRM = '.srm'
    HEADER_SIZE=86
    MARKER_SIZE=270
    BLOCK_SIZE=6

    attr_reader :properties, :markers, :data_points, :peak_powers

    def initialize(data)
      @data = data  
      @data_points = Array.new
      @markers = Array.new
      @peak_powers = Array.new
    end

    def parse(options = {})
      parse_header
      parse_markers
      parse_blocks
      parse_data_points
      parse_data_point_times

      if(options[:calculate_marker_values])
        calculate_marker_values()
      end

      if(options[:calculate_peak_power_values])
        calculate_peak_power_values(:durations => options[:durations], :total_duration => @markers.first.duration_seconds)
      end
    end

    def parse_header()
      str = @data.slice(0, HEADER_SIZE)
      @properties = SrmProperties.new
      @properties.ident=str.slice(0,4)
      @properties.srm_date = str.slice(4,2).unpack('S')[0]
      @properties.wheel_size = str.slice(6,2).unpack('S')[0]
      @properties.record_interval_numerator = str.slice(8,1).unpack('C')[0]
      @properties.record_interval_denominator = str.slice(9,1).unpack('C')[0]
      @properties.block_count = str.slice(10,2).unpack('S')[0]
      @properties.marker_count = str.slice(12,2).unpack('S')[0]
      @properties.comment = str.slice(16,70).toutf8.strip

      str=@data.slice(HEADER_SIZE + 
        (MARKER_SIZE * (@properties.marker_count + 1 )) + 
        (BLOCK_SIZE * @properties.block_count) , 6)

      @properties.zero_offset = str.slice(0,2).unpack('S')[0]
      @properties.slope = str.slice(2,2).unpack('S')[0]
      @properties.record_count = str.slice(4,2).unpack('S')[0]   
    end

    def parse_markers
      start = HEADER_SIZE
      count=0
      
      while count <= @properties.marker_count 
        str = @data.slice(start + (count * MARKER_SIZE), MARKER_SIZE)

        marker = Marker.new
        marker.comment = str.slice(0, 255).strip
        marker.active = str.slice(255)
        marker.start = str.slice(256,2).unpack('S')[0] - 1
        marker.end = str.slice(258,2).unpack('S')[0] - 1
        
        @markers << marker
        count=count + 1
      end
    end

    def parse_blocks
      count = 0
      start = HEADER_SIZE + (MARKER_SIZE * (@properties.marker_count + 1 ))
      @blocks = Array.new
      while count < @properties.block_count
        str=@data.slice(start + (count * BLOCK_SIZE), BLOCK_SIZE)
        
        block = Hash.new
        block[:time] = str.slice(0,4).unpack('I')[0]
        block[:count] = str.slice(4,2).unpack('S')[0].to_i

        @blocks << block
        count = count + 1
      end
    end

    def parse_data_points()
      count = 0
      start = HEADER_SIZE + (MARKER_SIZE * (@properties.marker_count + 1 )) + (BLOCK_SIZE * @properties.block_count) + 7
      total_distance = 0

      while count < @properties.record_count
        record=@data.slice(start + (count * 5), 5)
        byte1=record.slice(0)
        byte2=record.slice(1)
        byte3=record.slice(2)
        data_point = DataPoint.new
        
        data_point.time = count * @properties.record_interval
        data_point.power = ( (byte2 & 0x0F) | (byte3 << 4) ).to_f
        data_point.speed = ( ( ( (byte2 & 0xF0) << 3) | (byte1 & 0x7F) ) * 32 ) #stored in mm/s
        data_point.cadence = record.slice(3)
        data_point.heartrate = record.slice(4)
        
        total_distance = total_distance + (data_point.speed * @properties.record_interval) 
        data_point.distance = total_distance #in mm
        
        @data_points << data_point
        count=count + 1
      end
    end

    def parse_data_point_times
      count = 0
      @blocks.each { |block|
       relative_count = 0
        while relative_count < block[:count]
          @data_points[count].time_of_day =  block[:time]/100 + (@properties.record_interval*relative_count)
          @data_points[count].time_with_pauses = block[:time]/100 - @blocks[0][:time]/100 + (@properties.record_interval*(relative_count + 1))

          relative_count=relative_count+1
          count=count+1
        end
      }
     
      @properties.date_time = data_points.first.time_of_day.to_i
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