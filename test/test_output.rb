require "#{File.dirname __FILE__}/helper"
require 'semi-static/cli'

class TestOutput < Test::Unit::TestCase
    def test_output_files
        with_test_cli do |cli|
            cli.delete_output_dir = true
            cli.run
            
            assert_directory TEST_OUTPUT_DIR
            Dir.chdir TEST_OUTPUT_DIR do
                assert_file 'about.html'
                assert_file 'colophon.html'
            end
        end
    end
end
