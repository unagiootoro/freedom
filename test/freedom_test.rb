require "test_helper"

class FreedomTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Freedom::VERSION
  end
end
