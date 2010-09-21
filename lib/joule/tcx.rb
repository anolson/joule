require 'joule/tcx/parser'
require 'joule/tcx/properties'

module Joule
  module TCX
    FILE_EXTENSION = ".tcx"
    
    def TCX.is_tcx_file(extension)
      extension.eql?(FILE_EXTENSION)
    end
  end
end