require "#{File.dirname __FILE__}/helper"

class TestLayout < Test::Unit::TestCase
    def test_layout_list
        with_site(TEST_SOURCE_DIR) do |site|
            assert_not_nil site
            assert_not_nil site.layouts
            assert_equal 1, site.layouts.length
            assert_equal [ :default ], site.layouts.keys
            assert_not_nil site.layouts[:default]
        end
    end
end
