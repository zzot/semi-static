module SemiStatic
    # Page represents a static page in the site.  Page itself only
    # represents a single source file, but can have a Layout and any number
    # of Snippets, each of which has its own source file.  Page's modification
    # time is the most recent of itself, its layout, and any Snippets used.
    class Page < Base
        include Convertable
        
        ##
        # The Page's output directory
        attr_reader :output_dir

        ##
        # The Page's output path
        attr_reader :output_path

        ##
        # The Page's name
        attr_reader :name

        ##
        # The Page's URI
        attr_reader :uri
        
        ##
        # Initializes a new Page
        #
        # +site+:: The Site object we belong to
        # +path+:: The relative path to the source file
        def initialize(site, path)
            super
            @metadata = [ :title, :layout ]
            
            src_base = File.basename(source_path, source_ext)
            output_ext = File.extname(src_base)
            if output_ext.nil? || output_ext.empty?
                output_ext = '.html'
            else
                src_base = File.basename(src_base, output_ext)
            end
            @output_dir, src_file = File.split(source_path)
            
            if output_dir == '.'
                prefix = ''
            else
                prefix = "#{output_dir}/"
            end
            @name = "/#{prefix}#{src_base}"
            @output_path = "#{prefix}#{src_base}#{output_ext}"
            
            if src_base == 'index'
                @uri = "/#{output_dir}/"
            else
                @uri = "/#{output_path}"
            end
        end
    end
end
