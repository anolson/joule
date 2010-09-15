require 'fastercsv'
require 'joule/csv/parser'

module Joule
  module CSV
    FILE_EXTENSION = "csv"
    
    def CSV.parser(extension, data)
      header = FasterCSV.parse(data).shift
      if header[0].to_s.downcase.eql?("ibike")
        Joule::IBike::Parser.new(data)
      else
        Joule::PowerTap::Parser.new(data)
      end
    end
    
  end
end