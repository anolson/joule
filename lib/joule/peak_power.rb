module Joule
  class PeakPower
    include Joule::Hashable
    attr_accessor :duration, :value, :start
    
    def initialize(duration) 
      @duration = duration
      @value = 0
      @start = 0 
    end
    
  end
end