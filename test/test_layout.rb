$VERBOSE = false # Haml creates a lot of noise with this set

require "#{File.dirname __FILE__}/helper"

class TestLayout < Test::Unit::TestCase
    def test_layout_list
        with_test_site do |site|
            assert_not_nil site
            assert_not_nil site.layouts
            assert_equal 2, site.layouts.length
            assert_equal [ :default, :post ], site.layouts.keys.sort { |l,r| l.to_s <=> r.to_s }
            assert_not_nil site.layouts[:default]
            assert_not_nil site.layouts[:post]
        end
    end
    
    def test_default_layout
        with_test_site do |site|
            src = '<p>Hello World!</p>'
            dst = site.layouts[:default].render(src, site, :title => 'Layout Test')
            
            assert_equal ref('test_layout/default_layout.html'), dst
        end
    end
    
    class Post
        def id; 314159; end
        def title; "Test Post"; end
        def permalink; "http://example.com/2009/01/13/test-post.html"; end
        def author; "Josh Dady"; end
        def date; "January 13, 2009"; end
        def time; "11:52 AM"; end
        def comments_link; "#{permalink}##comments"; end
        def comment_count; 0; end
    end
    
    def test_post_layout
        with_test_site do |site|
            src = '<p>Hello World!</p>'
            
            post = Post.new
            dst = site.layouts[:post].render(src, site, :title => post.title, :post => post)

            assert_equal ref('test_layout/post_layout.html'), dst
        end
    end
end
