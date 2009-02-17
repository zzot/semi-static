require "#{File.dirname __FILE__}/helper"
require 'semi-static/cli'

class TestOutput < Test::Unit::TestCase
    def test_output_files
        with_test_cli do |cli|
            cli.delete_output_dir = true
            cli.run
            
            assert_directory TEST_OUTPUT_DIR
            Dir.chdir TEST_OUTPUT_DIR do
                assert_directory 'scripts'
                assert_file      'scripts/jquery-1.3.js'
                assert_file      'scripts/jquery-1.3.min.js'
                
                assert_file      'about.html'
                assert_file      'colophon.html'
                
                assert_directory '2008'
                assert_directory '2008/11'
                assert_directory '2008/11/24'
                assert_directory '2008/11/26'
                assert_directory '2008/12'
                assert_directory '2008/12/04'

                assert_file      '2008/index.html'
                assert_file      '2008/11/index.html'
                assert_file      '2008/11/24/index.html'
                assert_file      '2008/11/24/lighting-up.html'
                assert_file      '2008/11/26/index.html'
                assert_file      '2008/11/26/impressions.html'
                assert_file      '2008/12/index.html'
                assert_file      '2008/12/04/index.html'
                assert_file      '2008/12/04/the-working-mans-typeface.html'
            end
        end
    end
end
