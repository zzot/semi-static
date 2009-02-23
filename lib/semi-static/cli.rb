require 'optparse'
require 'webrick'

module SemiStatic
    class CLI
        include WEBrick
        
        attr_accessor :source_dir, :output_dir
        attr_accessor :delete_output_dir
        attr_accessor :server, :server_port
        attr_accessor :statistics
        
        def self.run
            cli = CLI.new
            opts = OptionParser.new do |opts|
                opts.banner = 'Usage: semi [<options>] [[<source path>] <output path>]'
                opts.separator ''
                opts.separator 'Options:'
                
                opts.on('-s', '--server [PORT]', Integer,
                        'Start a web server (on port PORT)') do |port|
                    cli.server = true
                    cli.server_port = port || 4000
                end
                
                opts.on('-d', '--[no-]delete', 'Delete output dir first') do |d|
                    cli.delete_output_dir = d
                end
                
                opts.on('-t', '--[no-]stats', 'Collect and display some stats.') do |t|
                    cli.statistics = t
                end
                
                opts.on_tail('-h', '--help', 'Show this message') do
                    puts opts
                    exit
                end
                
                opts.on_tail('-V', '--version', 'Show version number') do
                    path = File.join File.dirname(__FILE__), '..', '..', 'VERSION.yml'
                    version = File.open(path) { |io| YAML.load io }
                    puts "#{version[:major]}.#{version[:minor]}.#{version[:patch]}"
                end
            end
            opts.parse!
            
            case ARGV.size
            when 0
                cli.source_dir = '.'
                cli.output_dir = 'site'
            when 1
                cli.source_dir = '.'
                cli.output_dir = ARGV[0]
            when 2
                cli.source_dir = ARGV[0]
                cli.output_dir = ARGV[1]
            else
                puts 'Invalid options.  Run `semi --help` for assistance.'
                exit 1
            end
            
            cli.run
        end
        
        def run
            generate_site
            start_server
        end
        
      private
        def generate_site
            SemiStatic::Site.open(source_dir) do |site|
                FileUtils.rm_rf output_dir if delete_output_dir
                site.output output_dir
                
                site.stats.display if statistics
            end
        end
        
        # This function, short as it may be, is basically lifted from the
        # equivalent module inside Jekyll.
        def start_server
            if server
                s = HTTPServer.new :DocumentRoot => output_dir,
                                   :Port => server_port
                t = Thread.new { s.start }
            
                trap('INT') { s.shutdown }
                t.join
            end
        end
    end
end
