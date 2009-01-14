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
            assert_equal [ :Life, :Raves ], site.categories.keys.sort { |l,r| l.to_s <=> r.to_s }
        end
    end
    
    def test_post_tags
        with_test_site do |site|
            assert_not_nil site
            assert_not_nil site.tags
            assert_equal [ :'Auto Show', :'Catching Up', :'Colbert Report',
                           :'Comedy Central', :RSS, :Travel,
                           :Typography, :Work, :iPhone ],
                         site.tags.keys.sort { |l,r| l.to_s <=> r.to_s }
        end
    end
end
