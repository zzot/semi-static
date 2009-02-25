require 'optparse'
require 'webrick'
require 'directory_watcher'

module SemiStatic
    class CLI
        include WEBrick
        
        attr_accessor :source_dir, :output_dir
        attr_accessor :clean_first
        attr_accessor :start_server, :server_port
        attr_accessor :show_statistics
        attr_accessor :use_pygments
        attr_accessor :quick_mode
        attr_accessor :check_mtime
        attr_accessor :start_updater
        
        def initialize
            self.clean_first     = false
            self.start_server    = false
            self.show_statistics = false
            self.use_pygments    = true
            self.quick_mode      = false
            self.check_mtime     = true
            self.start_updater   = false
        end
        
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
                
                opts.on('-a', '--[no-]auto-update', 'Automatically update generated files') do |a|
                    cli.start_updater = a
                end
                
                opts.on('-c', '--[no-]clean', 'Clean the output dir first') do |d|
                    cli.clean_first = d
                end
                
                opts.on('-t', '--[no-]stats', 'Display conversion statistics') do |t|
                    cli.show_statistics = t
                end
                
                opts.on('-p', '--[no-]pygments', 'Use Pygments for code highlighting') do |p|
                    cli.use_pygments = p
                end
                
                opts.on('-q', '--[no-]quick-mode', 'Only convert a few posts (for testing)') do |q|
                    cli.quick_mode = q
                end
                
                opts.on('-m', '--[no-]mtime', 'Skip files that appear to be up-to-date') do |m|
                    cli.check_mtime = m
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
            Pygmentize.enabled = use_pygments
            SemiStatic::Site.open(source_dir) do |site|
                site.clean_first     = clean_first
                site.show_statistics = show_statistics
                site.quick_mode      = quick_mode
                site.check_mtime     = check_mtime
                
                site.output output_dir
                if start_updater
                    updater = DirectoryWatcher.new(source_dir)
                    updater.interval = 1
                    updater.glob = '{indices,layouts,pages,posts,snippets,stylesheets}/**/*'
                    updater.add_observer do |*args|
                        puts "[#{Time.now}] #{args.length} files changed."
                        site.output output_dir
                    end
                    updater.start
                    sleep 0 unless start_server
                end
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
