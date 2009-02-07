require 'optparse'

module SemiStatic
    module CLI
        HELP = "Usage:\n" +
               "    semi [ [ <source path >] <output path> ]\n" +
               "\n" +
               "Options:\n"
        
        def self.run
            options = {}
            parser = OptionParser.new do |opts|
                opts.banner = HELP
                
                opts.on('--server [PORT]', 'Start a web server') do |port|
                    options[:server] = true
                    options[:server_port] = port || 4000
                end
            end
            parser.parse!
            
            source_dir = nil
            output_dir = nil
            case ARGV.size
            when 0
                source_dir = '.'
                output_dir = File.join(source_dir, 'site')
            when 1
                source_dir = '.'
                output_dir = ARGV[0]
            when 2
                source_dir = ARGV[0]
                output_dir = ARGV[1]
            else
                puts 'Invalid options.  Run `semi --help` for assistance.'
                exit 1
            end
            
            SemiStatic::Site.open(source_dir) do |site|
                site.output output_dir
            end
            
            if options[:server]
                start_server output_dir, options[:server_port]
            end
        end
        
        # This function, short as it may be, is basically lifted from the
        # equivalent module inside Jekyll.
        def self.start_server(path, port)
            require 'webrick'
            include WEBrick
            
            s = HTTPServer.new :Port => port, :DocumentRoot => path
            t = Thread.new { s.start }
            
            trap('INT') { s.shutdown }
            t.join
        end
    end
end
