require 'joule/array'
require 'joule/exception'
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
    if(Joule::SRM::is_srm_file(extension))
      Joule::SRM::Parser.new(data)
    elsif(Joule::TCX::is_tcx_file(extension))
      Joule::TCX::Parser.new(data)
    elsif(Joule::CSV::is_csv_file(extension))
      Joule::CSV.parser(extension, data)      
    else
      raise UnsupportedFileTypeException
    end
  end
  
end

