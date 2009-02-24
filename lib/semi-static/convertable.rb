module SemiStatic
    module Convertable
        include ERB::Util
        include Pygmentize
        
        def _content(options={})
            return @content unless @content.nil?
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
                    ERB.new(self.source_content, nil, '-').result(binding)
                when '.html'
                    self.source_content
                else
                    raise ArgumentError, "Unsupported format: #{self.source_path}"
                end
            end
        end
        
        def content(options={})
            options = { :page => self }.merge(options)
            return _content(options)
        end
        
        def render(options={})
            content = self.content(options)
            unless !@metadata.include?(:layout) || self.layout.nil?
                page = options.include?(:page) ? options[:page] : self
                content = site.layouts[layout.to_sym].render(options.merge(:page => page, :content => content))
            end
            return content
        end
        
        def snippet(name)
            name = name.to_s
            site.snippets[name].render :page => self
        end
        
        # This method is adapted from Haml::Buffer#parse_object_ref -- it's
        # used to make it easier for Haml and ERB layouts to generate the
        # same output so I can use the same test output for both.
        def object_ref(object)
            return '' if object.nil?
            name = underscore(object.class)
            id = "#{name}_#{object.id || 'new'}"
            return "class='#{name}' id='#{id}'"
        end
        
        # Changes a word from camel case to underscores.  Based on the method
        # of the same name in Rails' Inflector, but copied here so it'll run
        # properly without Rails.
        def underscore(camel_cased_word)
            camel_cased_word.to_s.gsub(/::/, '_').
            gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
            gsub(/([a-z\d])([A-Z])/,'\1_\2').
            tr("-", "_").
            downcase
        end
    end
end
