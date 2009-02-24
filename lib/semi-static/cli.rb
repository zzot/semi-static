require 'optparse'
require 'webrick'

module SemiStatic
    class CLI
        include WEBrick
        
        attr_accessor :source_dir, :output_dir
        attr_accessor :clean_first
        attr_accessor :start_server, :server_port
        attr_accessor :show_statistics
        
        def self.run
            cli = CLI.new
            opts = OptionParser.new do |opts|
                opts.banner = 'Usage: semi [<options>] [[<source path>] <output path>]'
                opts.separator ''
                opts.separator 'Options:'
                
                opts.on('-s', '--server [PORT]', Integer,
                        'Start a web server (on port PORT)') do |port|
                    cli.start_server = true
                    cli.server_port = port || 4000
                end
                
                opts.on('-c', '--[no-]clean', 'Clean the output dir first') do |d|
                    cli.clean_first = d
                end
                
                opts.on('-t', '--[no-]stats', 'Display conversion statistics') do |t|
                    cli.show_statistics = t
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
            SemiStatic::Site.open(source_dir) do |site|
                site.clean_first     = clean_first
                site.show_statistics = show_statistics
                
                site.output output_dir
                if start_server
                    server = HTTPServer.new :DocumentRoot => output_dir,
                                            :Port => server_port
                    thread = Thread.new { server.start }
                    trap('INT') { server.shutdown }
                    thread.join
                end
            end
        end
    end
end
