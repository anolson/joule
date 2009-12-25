$:.unshift File.join(File.dirname(__FILE__), 'lib')

require 'rubygems'
require 'joule'

require 'test/unit'


module Joule
  class TestTcxParser < Test::Unit::TestCase

    def test_parse_with_power()
      xml = IO.read('files/2009-11-29-17-29-07.tcx')
      tcx_parser = TcxParser.new(xml)
      tcx_parser.parse  
      data_points = tcx_parser.data_points

      
      assert_equal 3410, data_points.size 
      assert_equal 3409, data_points.last.time
      assert_equal 3479, data_points.last.time_with_pauses
      assert_equal 66426, data_points.last.time_of_day
      
      assert_equal 1, tcx_parser.markers.size 
    
    end
    # 
    # def test_parse_with_power_and_multiple_laps()      
    #   xml = IO.read('files/2009-12-01-15-26-32.tcx')
    #   tcx_parser = TcxParser.new(xml)
    #   tcx_parser.parse  
    #   data_points = tcx_parser.data_points
    #   
    #   assert_equal 9619, data_points.size 
    # end

    # def test_parse_with_speed()
    #   xml = IO.read('files/activity_8755231.tcx')
    #   tcx_parser = TcxParser.new(xml)
    #   tcx_parser.parse  
    #   data_points = tcx_parser.data_points
    #   
    #   assert_equal 17734, data_points.size 
    # end


  end
end