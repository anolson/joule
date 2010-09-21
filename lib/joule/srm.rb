require 'joule/srm/parser'
require 'joule/srm/properties'

module Joule
  module SRM
    FILE_EXTENSION = ".srm"
    
    def SRM.is_srm_file(extension)
      extension.eql?(FILE_EXTENSION)
    end
    
  end
end