module SemiStatic
    module Convertable
        def _render(options={})
            for name, value in options
                eval "#{name.to_s} = options[name]"
            end
            
            case self.source_ext
            when '.md', '.markdown'
                Maruku.new(self.source_content).to_html
            when '.haml'
                Haml::Engine.new(self.source_content).render(binding)
            when '.html'
                self.source_content
            else
                raise ArgumentError, "Unsupported format: #{self.source_path}"
            end
        end
        
        def render(options={})
            options = { :page => self }.merge(options)
            content = _render(options)
            unless self.layout.nil?
                content = site.layouts[layout.to_sym].render(options.merge(:content => content))
            end
            return content
        end
        
        def content_type_attrs
            { 'http-equiv' => 'Content-type', :content => 'text/html; charset=utf-8' }
        end
        
        def body_attrs
            {}
        end
    end
end
