module SemiStatic
    ##
    # Layout embeds the formatted output of a Convertable within a large document.
    class Layout < Base
        include Convertable
        
        ##
        # The Layout's name
        attr_reader :name
        
        ##
        # Initialize a new Layout
        #
        # +site+: The Site we belong to.
        # +path+: The path to the source file.
        def initialize(site, path)
            super
            @metadata = [ :layout ]
            
            @name = File.basename(source_path, source_ext)
        end
    end
end
