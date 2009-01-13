$VERBOSE = false # Haml creates a lot of noise with this set

require "#{File.dirname __FILE__}/helper"

class TestLayout < Test::Unit::TestCase
    def test_layout_list
        with_site(TEST_SOURCE_DIR) do |site|
            assert_not_nil site
            assert_not_nil site.layouts
            assert_equal 1, site.layouts.length
            assert_equal [ :default ], site.layouts.keys
            assert_not_nil site.layouts[:default]
        end
    end
    
    def test_default_layout
        with_site(TEST_SOURCE_DIR) do |site|
            src = '<p>Hello World!</p>'
            dst = site.layouts[:default].render(src, site, :title => 'Layout Test')
            ref = <<EOF
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html lang='en-US' xml:lang='en-US' xmlns='http://www.w3.org/1999/xhtml'>
  <head>
    <meta content='text/html; charset=utf-8' http-equiv='Content-type' />
    <title>Layout Test</title>
    <meta content='Josh Dady' name='author' />
  </head>
  <body>
    <div id='site'>
      <div id='header'>
        <h1 class='title'>
          <a href='/'>Test Website</a>
        </h1>
        <ul class='nav'>
          <li class='nav-home'>
            <a href='/'>Home</a>
          </li>
          <li class='nav-about'>
            <a href='/about.html'>About</a>
          </li>
          <li class='nav-colophon'>
            <a href='/colophon.html'>Colophon</a>
          </li>
        </ul>
      </div>
      <div id='body'><p>Hello World!</p></div>
      <div id='footer'>
        <p>
          Copyright © 2003–2009 Josh Dady.
          <a href='/terms.html'>Some rights reserved.</a>
        </p>
      </div>
    </div>
  </body>
</html>
EOF
            
            assert_equal ref, dst
        end
    end
end
