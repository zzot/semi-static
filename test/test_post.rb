require "#{File.dirname __FILE__}/helper"

class TestPost < Test::Unit::TestCase
    def test_post_list
        with_test_site do |site|
            assert_not_nil site
            assert_not_nil site.posts
            assert_equal 3, site.posts.length
            assert_not_nil site.posts['2008-12-04-the-working-mans-typeface']
            assert_not_nil site.posts['2008-11-26-impressions']
            assert_not_nil site.posts['2008-11-24-lighting-up']
        end
    end
    
    def test_post_categories
        with_test_site do |site|
            assert_not_nil site
            assert_not_nil site.categories
            assert_equal [ :life, :raves ], site.categories.slugs
            assert_equal [ 'Life', 'Raves' ], site.categories.names
        end
    end
    
    def test_post_tags
        with_test_site do |site|
            assert_not_nil site
            assert_not_nil site.tags
            assert_equal [ :'auto-show', :'catching-up', :'colbert-report',
                           :'comedy-central', :iphone, :rss, :travel,
                           :typography, :work ],
                         site.tags.slugs
        end
    end
    
    def test_post_lighting_up
        with_test_site_post('2008-11-24-lighting-up') do |site,post|
            # Make sure we got a post, and that its name matches our request
            assert_equal '2008-11-24-lighting-up', post.name
            
            # Test the various path/uri attributes
            assert_equal '_posts/2008-11-24-lighting-up.markdown', post.source_path
            assert_equal '2008/11/24/lighting-up.html', post.output_path
            assert_equal '/2008/11/24/lighting-up.html', post.uri
            
            # Test that the metadata was processed correctly
            assert_equal 'Lighting Up', post.title
            assert_equal 'post', post.layout
            assert_equal site.categories['Life'], post.category
            
            assert_render_equal_ref 'test_post/lighting-up.html', post
        end
    end
end
