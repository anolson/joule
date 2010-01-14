module Joule
  module TCX
    class Properties
      attr_accessor :record_interval, :date_time

      def start_time_in_seconds
        (@date_time.hour * 3600) + (@date_time.min * 60) + @date_time.sec
      end
      
      
    end  
  end
end