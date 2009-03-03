module SemiStatic
    ##
    # Index is used to generate several site index pages that don't have a
    # fixed path (i.e., the yearly index pages) from a single source file.
    # It can have a Layout and use any number of Snippets.  Index's modification
    # time is the most recent of itself, its layout, and any Snippets used.
    # Indices are also considered out-of-date if any posts in the index's range
    # are changed.
    class Index < Base
        include Convertable
        
        ##
        # Posts in range for the Index's current path.
        attr_accessor :posts
        
        ##
        # The Index's current context (usually a Date).
        attr_accessor :context
        
        ##
        # The index title
        attr_accessor :title
        
        ##
        # Initializes a new Index
        #
        # +site+:: The Site object we belong to
        # +path+:: The relative path to the source file
        def initialize(site, path)
            super
            @metadata = [ :layout ]
        end
    end
end
