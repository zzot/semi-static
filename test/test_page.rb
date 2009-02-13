require "#{File.dirname __FILE__}/helper"

class TestPage < Test::Unit::TestCase
    def test_page_list
        with_test_site do |site|
            assert_not_nil site.pages
            assert_equal 3, site.pages.length
            assert_equal [ '/about', '/colophon', '/feed' ], site.pages.keys.sort
            assert_not_nil site.pages['/about']
            assert_not_nil site.pages['/colophon']
            assert_not_nil site.pages['/feed']
        end
    end
    
    def test_about_page
        with_test_site_page('/about') do |site, page|
            # Make sure we got a page, and that its name matches our request
            assert_equal '/about', page.name
            
            # Test the various path/uri attributes
            assert_equal 'about.md', page.source_path
            assert_equal 'about.html', page.output_path
            assert_equal '/about.html', page.uri
            
            # Test that the metadata was processed correctly
            assert_equal 'About this site', page.title
            assert_equal 'default', page.layout
            
            assert_render_equal_ref 'test_page/about.html', page
        end
    end
    
    def test_colophon_page
        with_test_site_page('/colophon') do |site, page|
            # Make sure we got a page, and that its name matches our request
            assert_equal '/colophon', page.name
            
            # Test the various path/uri attributes
            assert_equal 'colophon.md', page.source_path
            assert_equal 'colophon.html', page.output_path
            assert_equal '/colophon.html', page.uri
            
            # Test that the metadata was processed correctly
            assert_equal 'Colophon', page.title
            assert_equal 'default', page.layout
            
            assert_render_equal_ref 'test_page/colophon.html', page
        end
    end
    
    def test_feed_page
        with_test_site_page('/feed') do |site, page|
            # Make sure we got what we asked for
            assert_equal '/feed', page.name
            
            # Test the various path/uri attributes
            assert_equal 'feed.xml.erb', page.source_path
            assert_equal 'feed.xml', page.output_path
            assert_equal '/feed.xml', page.uri
            
            # Test that the metadata was processed correctly
            assert_equal nil, page.title
            assert_equal nil, page.layout
            
            # assert_render_equal_ref 'test_page/feed.xml', page
        end
    end
end
