module SemiStatic
    # Base represents a single source file and its associated metadata.
    # Base loads the source file, and strips and parses any metadata set
    # in the file's header.  It stores an absolute path to the file so we
    # can refer to it later.
    class Base
        ##
        # The associated Site object
        attr_reader :site
        
        ##
        # The relative path to the source file
        attr_reader :source_path
        
        ##
        # The source file's extension
        attr_reader :source_ext
        
        ##
        # The source file's contents
        attr_reader :source_content
        
        ##
        # The metadata found in the file's header
        attr_reader :source_metadata
        
        ##
        # The absolute path to the source file
        attr_reader :full_source_path
        
        ##
        # Initializes a new Base
        #
        # +site+:: The Site object we belong to
        # +path+:: The relative path to the source file
        def initialize(site, path)
            @site = site
            @source_path = path
            @source_ext = File.extname(source_path)
            @full_source_path = File.expand_path(source_path)
            @metadata = []
            
            load
        end
        
        ##
        # Get the modification time of the source file.
        def source_mtime
            File.mtime(@full_source_path)
        end
        
      protected
        ##
        # Read the source file and parse any metadata in the file header.
        def load
            contents = File.read File.join(full_source_path)
            if contents =~ /^(---\s*\n.*?)\n---\s*\n/m
                @source_content, @source_metadata = contents[($1.size + 5) .. -1], YAML.load($1)
            else
                @source_content, @source_metadata = contents, {}
            end
            @source_metadata.symbolize_keys
        end
        
        def method_missing(method, *args) #:nodoc:
            name = method.to_sym
            if @metadata.include?(name)
                return source_metadata[name]
            else
                super
            end
        end
    end
end
