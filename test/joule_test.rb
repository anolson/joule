require File.dirname(__FILE__) + '/helper'

module Joule
  class JouleTest < Joule::TestCase
    
    def test_parser_for_srm
      data = IO.read(SRM_FILE)
      parser = Joule::parser(".srm", data)
      assert_kind_of Joule::SRM::Parser, parser
    end
    
    def test_parser_for_tcx
      data = IO.read(SRM_FILE)
      parser = Joule::parser(".tcx", data)
      assert_kind_of Joule::TCX::Parser, parser
    end
    
    def test_parser_for_powertap
      data = IO.read(POWER_TAP_FILE)
      parser = Joule::parser(".csv", data)
      assert_kind_of Joule::PowerTap::Parser, parser
    end
    
    def test_parser_for_ibike
      data = IO.read(IBIKE_FILE)
      parser = Joule::parser(".csv", data)
      assert_kind_of Joule::IBike::Parser, parser
    end
    
    def test_parser_for_invalid_file_type
      assert_raise UnsupportedFileTypeException do
        parser = Joule::parser(".wko", "")
      end
    end
    
  end
end