$VERBOSE = false # Haml creates a lot of noise with this set

require "#{File.dirname __FILE__}/helper"

class TestPage < Test::Unit::TestCase
    def test_page_list
        with_site(TEST_SOURCE_DIR) do |site|
            assert_not_nil site
            assert_not_nil site.pages
            assert_equal 2, site.pages.length
            assert_equal [ './colophon.html', './about.html' ], site.pages.keys
            assert_not_nil site.pages['./about.html']
            assert_not_nil site.pages['./colophon.html']
        end
    end
end
