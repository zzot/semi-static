require 'test/unit'
require "#{File.dirname __FILE__}/../lib/semi-static"

class Test::Unit::TestCase
    TEST_SOURCE_DIR = File.join(File.dirname(__FILE__), 'source')
    
    def with_site(source_dir)
        raise ArugmentError, "block required" unless block_given?
        site = SemiStatic::Site.new source_dir
        yield site
    end
    
    def ref(name)
        path = File.join File.dirname(__FILE__), 'ref', name
        return File.read(path)
    end
end
