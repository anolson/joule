require 'joule/array'
require 'joule/hashable'

require 'joule/data_point'
require 'joule/marker'
require 'joule/calculator'
require 'joule/peak_power'
require 'joule/units_conversion'
require 'joule/workout'

require 'joule/base'
require 'joule/csv'
require 'joule/ibike'
require 'joule/powertap'
require 'joule/srm'
require 'joule/tcx'

module Joule
  def Joule.parser(extension, data) 
    if(extension.eql?(Joule::SRM::FILE_EXTENSION))
      Joule::SRM::Parser.new(data)
    elsif(extension.eql?(Joule::TCX::FILE_EXTENSION))
      Joule::TCX::Parser.new(data)
    else
      Joule::CSV.parser(extension, data)      
    end
  end
end

