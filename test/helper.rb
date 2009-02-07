$VERBOSE = false # Haml creates a lot of noise with this set

require 'tempfile'
require 'test/unit'
require "#{File.dirname __FILE__}/../lib/semi-static"

class Test::Unit::TestCase
    TEST_SOURCE_DIR = File.join(File.dirname(__FILE__), 'source')
    
    def with_test_site
        raise ArgumentError, "block required" unless block_given?
        site = SemiStatic::Site.open(TEST_SOURCE_DIR) do |site|
            assert_not_nil site
            yield site
        end
    end
    
    def with_test_site_page(page_name)
        raise ArgumentError, "block required" unless block_given?
        with_test_site do |site|
            page = site.pages[page_name]
            assert_not_nil page
            yield site, page
        end
    end
    
    def with_test_site_post(post_name)
        raise ArgumentError, "block required" unless block_given?
        with_test_site do |site|
            post = site.posts[post_name]
            assert_not_nil post
            yield site, post
        end
    end
    
    def ref(name)
        path = File.join File.dirname(__FILE__), 'ref', name
        return File.read(path)
    end
    
    def diff(left, right, options={})
        Tempfile.open('left') do |t1|
            t1.write left
            t1.close
            Tempfile.open('right') do |t2|
                t2.write right
                t2.close
                
                cmd = 'diff -ub -I \'^[[:space:]]*$\''
                
                cmd << " --label '#{options[:left]}'" if options.include?(:left)
                cmd << " #{t1.path}"
                
                cmd << " --label '#{options[:right]}'" if options.include?(:right)
                cmd << " #{t2.path}"
                
                return `#{cmd}`
            end
        end
    end

    def assert_equal_diff(expected, actual, diff_options={})
        msg = diff expected, actual, diff_options
        assert_block(msg) { expected == actual }
    end
    
    def assert_render_equal_ref(ref_name, renderable, render_options={}, diff_options={})
        expected = ref(ref_name)
        actual = renderable.render(render_options)
        
        diff_options[:left] = ref_name unless diff_options.include?(:left)
        diff_options[:right] = renderable.output_path unless diff_options.include?(:right)
        
        msg = diff expected, actual, diff_options
        assert_block(msg) { $?.success? }
    end
end
