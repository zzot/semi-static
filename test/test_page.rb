$VERBOSE = false # Haml creates a lot of noise with this set

require "#{File.dirname __FILE__}/helper"

class TestPage < Test::Unit::TestCase
    def test_page_list
        with_test_site do |site|
            assert_not_nil site
            assert_not_nil site.pages
            assert_equal 2, site.pages.length
            assert_equal [ './about.html', './colophon.html' ], site.pages.keys.sort
            assert_not_nil site.pages['./about.html']
            assert_not_nil site.pages['./colophon.html']
        end
    end
end
