$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'rubygems'
require 'joule'
require 'test/unit'
require 'lib/float'

module Joule
  class TestCase < Test::Unit::TestCase
    ASSETS_DIRECTORY = File.expand_path File.join(File.dirname(__FILE__), 'files')
    IBIKE_FILE = File.join(ASSETS_DIRECTORY, 'ibike.csv')   
    POWER_TAP_FILE = File.join(ASSETS_DIRECTORY, '11202008.csv')    
    RAW_POWER_VALUES_FILE = File.join(ASSETS_DIRECTORY, 'power_values.txt')
    
    SRM_FILE = File.join(ASSETS_DIRECTORY, 'A112008A.srm')
    
    TCX_FILE_WITH_POWER = File.join(ASSETS_DIRECTORY, '2009-11-29-17-29-07.tcx')
    TCX_FILE_WITH_POWER_AND_MULTIPLE_MARKERS = File.join(ASSETS_DIRECTORY, '2009-11-29-17-29-07.tcx')
    TCX_FILE_WITH_SPEED = File.join(ASSETS_DIRECTORY, 'activity_8755231.tcx')

    unless RUBY_VERSION >= '1.9'
      undef :default_test
    end
    
  end
end