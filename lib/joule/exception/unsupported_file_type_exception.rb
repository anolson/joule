class UnsupportedFileTypeException < Exception
  
  def initialize
    message = "Unsupported file type.  Valid file types include SRM (.srm), PowerTap (.csv), iBike (.csv), and Garmin (.tcx)."
  end
  
end