require 'kconv'

module Joule
  module SRM
    class Parser < Joule::Base::Parser
       SRM = '.srm'
       HEADER_SIZE=86
       MARKER_SIZE=270
       BLOCK_SIZE=6

       def parse_workout()
         parse_markers
         parse_blocks
         parse_data_points
         parse_data_point_times
       end
       
       def parse_properties()
         str = @data.slice(0, HEADER_SIZE)
         @workout.properties = Joule::SRM::Properties.new
         @workout.properties.ident=str.slice(0,4)
         @workout.properties.srm_date = str.slice(4,2).unpack('S')[0]
         @workout.properties.wheel_size = str.slice(6,2).unpack('S')[0]
         @workout.properties.record_interval_numerator = str.slice(8,1).unpack('C')[0]
         @workout.properties.record_interval_denominator = str.slice(9,1).unpack('C')[0]
         @workout.properties.block_count = str.slice(10,2).unpack('S')[0]
         @workout.properties.marker_count = str.slice(12,2).unpack('S')[0]
         @workout.properties.comment = str.slice(16,70).toutf8.strip

         str=@data.slice(HEADER_SIZE + 
           (MARKER_SIZE * (@workout.properties.marker_count + 1 )) + 
           (BLOCK_SIZE * @workout.properties.block_count) , 6)

         @workout.properties.zero_offset = str.slice(0,2).unpack('S')[0]
         @workout.properties.slope = str.slice(2,2).unpack('S')[0]
         @workout.properties.record_count = str.slice(4,2).unpack('S')[0]   
       end

       private
       def parse_markers
         marker_offset = HEADER_SIZE

         (@workout.properties.marker_count + 1).times { |i|
           str = @data.slice(marker_offset + (i * MARKER_SIZE), MARKER_SIZE)

           marker = Marker.new
           marker.comment = str.slice(0, 255).strip
           marker.active = str.slice(255)
           marker.start = str.slice(256,2).unpack('S')[0] - 1
           marker.end = str.slice(258,2).unpack('S')[0] - 1
           @workout.markers << marker        
         }

       end

       def parse_blocks
         block_offset = HEADER_SIZE + (MARKER_SIZE * (@workout.properties.marker_count + 1 ))

         @blocks = Array.new
         @workout.properties.block_count.times {|i|
           str=@data.slice(block_offset + (i * BLOCK_SIZE), BLOCK_SIZE)

           block = Hash.new
           block[:time] = str.slice(0,4).unpack('I')[0]
           block[:count] = str.slice(4,2).unpack('S')[0].to_i
           @blocks << block
         }
       end

       def parse_data_points()
         count = 0
         start = HEADER_SIZE + (MARKER_SIZE * (@workout.properties.marker_count + 1 )) + (BLOCK_SIZE * @workout.properties.block_count) + 7
         total_distance = 0.0

         while count < @workout.properties.record_count
           record=@data.slice(start + (count * 5), 5)
           byte1=record.slice(0)
           byte2=record.slice(1)
           byte3=record.slice(2)
           data_point = DataPoint.new

           data_point.time = count * @workout.properties.record_interval
           data_point.power = ( (byte2 & 0x0F) | (byte3 << 4) ).to_f
           data_point.speed = ( ( ( (byte2 & 0xF0) << 3) | (byte1 & 0x7F) ) * 32 ) #stored in mm/s
           data_point.cadence = record.slice(3)
           data_point.heartrate = record.slice(4)

           total_distance = total_distance + (data_point.speed * @workout.properties.record_interval) 
           data_point.distance = total_distance #in mm

           @workout.data_points << data_point
           count=count + 1
         end
       end

       def parse_data_point_times
         count = 0
         @blocks.each { |block|
          relative_count = 0
           while relative_count < block[:count]
             @workout.data_points[count].time_of_day =  block[:time]/100 + (@workout.properties.record_interval*relative_count)
             @workout.data_points[count].time_with_pauses = block[:time]/100 - @blocks[0][:time]/100 + (@workout.properties.record_interval*(relative_count + 1))

             relative_count=relative_count+1
             count=count+1
           end
         }

         @workout.properties.date_time = @workout.data_points.first.time_of_day.to_i
       end

     end
  end
end