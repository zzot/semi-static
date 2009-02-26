module SemiStatic
    class Snippet < Base
        include Convertable
        
        ##
        # Snippet Name
        attr_reader :name
        
        ##
        # Initialize a new Snippet.
        #
        # +site+: The Site we belong to.
        # +path+: Path to the source file.
        def initialize(site, path)
            super
            @name = File.basename(source_path, source_ext)
        end
    end
end
