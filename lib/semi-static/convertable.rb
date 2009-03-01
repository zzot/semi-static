module SemiStatic
    ##
    # Support conversion of the source file into another format.
    module Convertable
        include ERB::Util
        
        def load #:nodoc:
            @content = nil
            if layout
                layout.load
            end
            super
        end
        
        ##
        # Format the source file.
        def content(options={})
            return @content unless @content.nil?
            
            options = { :page => self }.merge(options)
            for name, value in options
                eval "#{name.to_s} = options[name]"
            end

            site.stats.record(self.class.name.split('::').last, source_path) do
                case self.source_ext
                when '.md', '.markdown'
                    @content = Maruku.new(self.source_content).to_html
                when '.haml'
                    Haml::Engine.new(self.source_content, :filename => source_path).render(binding)
                when '.erb'
                    erb = ERB.new self.source_content, nil, '-'
                    erb.filename = source_path
                    erb.result(binding)
                when '.html'
                    self.source_content
                else
                    raise ArgumentError, "Unsupported format: #{self.source_path}"
                end
            end
        end
        
        def layout_name #:nodoc:
            unless source_metadata.nil? || !source_metadata.include?(:layout)
                source_metadata[:layout].to_sym
            end
        end
        
        def layout #:nodoc:
            if layout_name.nil?
                return nil
            else
                return site.layouts[layout_name.to_sym]
            end
        end
        
        ##
        # Add the layout used (if any) to the list of files used to determine
        # the objects modification time.
        def source_mtime
            mtime = super
            if layout && layout.source_mtime > mtime
                mtime = layout.source_mtime
            end
            return mtime
        end
        
        ##
        # Wrap the formatted source file in the Layout (if any).
        def render(options={})
            content = self.content(options)
            if layout
                options = { :page => self }.merge options
                content = layout.render(options.merge( :content => content ))
            end
            return content
        end
        
        ##
        # Helper method used to insert a Snippet into the formatted output.
        def snippet(name)
            name = name.to_s
            site.snippets[name].render :page => self
        end
        
        # This method is adapted from Haml::Buffer#parse_object_ref -- it's
        # used to make it easier for Haml and ERB layouts to generate the
        # same output so I can use the same test output for both.
        def object_ref(object) #:nodoc:
            return '' if object.nil?
            name = underscore(object.class)
            id = "#{name}_#{object.id || 'new'}"
            return "class='#{name}' id='#{id}'"
        end
        
        # Changes a word from camel case to underscores.  Based on the method
        # of the same name in Rails' Inflector, but copied here so it'll run
        # properly without Rails.
        def underscore(camel_cased_word) #:nodoc:
            camel_cased_word.to_s.gsub(/::/, '_').
            gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
            gsub(/([a-z\d])([A-Z])/,'\1_\2').
            tr("-", "_").
            downcase
        end
    end
end
