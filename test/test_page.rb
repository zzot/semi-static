require "#{File.dirname __FILE__}/helper"

class TestPage < Test::Unit::TestCase
    def test_page_list
        with_test_site do |site|
            assert_not_nil site.pages
            assert_equal 2, site.pages.length
            assert_equal [ '/about', '/colophon' ], site.pages.keys.sort
            assert_not_nil site.pages['/about']
            assert_not_nil site.pages['/colophon']
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
            
            assert_equal ref('test_page/about.html'), page.render
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
            
            assert_equal ref('test_page/colophon.html'), page.render
        end
    end
end
