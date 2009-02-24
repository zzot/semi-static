module SemiStatic
    module Pygmentize
        LEXER_FORMAT = /^[a-z]+$/i
        
        def pygmentize(code, lang)
            Pygmentize.pygmentize code, lang
        end

        def self.pygmentize(code, lang)
            unless lang =~ LEXER_FORMAT
                raise ArgumentError, "invalid lexer: #{lang}"
            end
        
            Tempfile.open('semistatic-pygmentize') do |temp|
                temp.write code
                temp.close
            
                cmd = "pygmentize -f html -l #{lang} #{temp.path}"
                IO.popen(cmd) do |proc|
                    return proc.read
                end
            end
        end
        
        @@enabled = false
        def self.enabled
            @@enabled
        end
        def self.enabled=(value)
            @@enabled = value
        end
    end
end

module MaRuKu
    module Out::HTML
        alias_method :to_html_code_without_pygments, :to_html_code
        def to_html_code_with_pygments
            if SemiStatic::Pygmentize.enabled
                source = self.raw_code
                lang = self.attributes[:lang] || 'text'
                html = SemiStatic::Pygmentize.pygmentize source, lang
                doc = Document.new html, :respect_whitespace => :all

                add_ws doc.root
            else
                to_html_code_without_pygments
            end
        end
        alias_method :to_html_code, :to_html_code_with_pygments
    end
end
