require 'test/unit'
require "#{File.dirname __FILE__}/../lib/semi-static"

class Test::Unit::TestCase
    TEST_SOURCE_DIR = File.join(File.dirname(__FILE__), 'source')
    
    def with_test_site
        raise ArgumentError, "block required" unless block_given?
        site = SemiStatic::Site.open(TEST_SOURCE_DIR) do |site|
            yield site
        end
    end
    
    def with_test_site_page(page_name)
        raise ArgumentError, "block required" unless block_given?
        with_test_site do |site|
            assert_not_nil site
            yield site, site.pages[page_name]
        end
    end
    
    def ref(name)
        path = File.join File.dirname(__FILE__), 'ref', name
        return File.read(path)
    end
end
