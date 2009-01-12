require "#{File.dirname __FILE__}/helper"

class TestLayout < Test::Unit::TestCase
    def test_layout_list
        with_site(TEST_SOURCE_DIR) do |site|
            assert_not_nil site
        end
    end
end
