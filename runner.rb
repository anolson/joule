$:.unshift File.join(File.dirname(__FILE__), 'lib')

require 'rubygems'
require 'joule'
module Joule
  xml = IO.read('2009-12-01-15-26-32.tcx')
  #xml = IO.read('activity_8755231.tcx')
  #
  # xml = IO.read('2009-11-29-17-29-07.tcx')
  tcxParser = TcxParser.new(xml)
  tcxParser.parse  
end
