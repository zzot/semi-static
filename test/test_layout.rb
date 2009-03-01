require "#{File.dirname __FILE__}/helper"

class TestLayout < Test::Unit::TestCase
    def test_layout_list
        with_test_site do |site|
            assert_not_nil site.layouts
            assert_equal 2, site.layouts.length
            assert_equal [ :default, :post ], site.layouts.keys.sort { |l,r| l.to_s <=> r.to_s }
            assert_not_nil site.layouts[:default]
            assert_not_nil site.layouts[:post]
        end
    end
    
    class Page
        def title; 'Layout Test'; end
    end
    
    def test_default_layout
        with_test_site do |site|
            src = '<p>Hello World!</p>'
            layout = site.layouts[:default]
            
            assert_render_equal_ref 'test_layout/default_layout.html', layout,
                                    { :content => src, :page => Page.new }, { :right => 'default.html' }
        end
    end
    
    class Post
        def id; 314159; end
        def title; "Test Post"; end
        def uri; "/2009/01/13/test-post.html"; end
        def permalink; "/2009/01/13/test-post.html"; end
        def comments_link; "#{uri}#comments"; end
        def author; "Josh Dady"; end
        def created; Time.local(2009, 1, 13); end
        def time?; true; end
        def time; "11:52 AM"; end
        def tags; []; end
        def comments_link; "#{permalink}##comments"; end
        def comment_count; 0; end
    end
    
    def test_post_layout
        with_test_site do |site|
            src = '<p>Hello World!</p>'
            layout = site.layouts[:post]
            
            assert_render_equal_ref 'test_layout/post_layout.html', layout,
                                    { :content => src, :page => Post.new }, { :right => 'post.html' }
        end
    end
end
