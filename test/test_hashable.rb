require File.dirname(__FILE__) + '/helper'

module Joule
  class TestHashable < Joule::TestCase
    include Joule::Hashable
    
    attr_accessor :color
    
    def setup
      @color = "blue"
    end 
    
    def test_to_hash
      hash = self.to_hash
      assert_equal "blue", hash[:color]
    end
  end
end