module SemiStatic
    module Pygmentize
        LEXER_FORMAT = /^[a-z]+$/i
        
        def pygmentize(code, lang)
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
    end
    
    module PygmentizeMarkdown
        extend Pygmentize
        
        CODE_BLOCK = /^~~~/
        CODE_BLOCK_WITH_LEXER = /^~~~[ \t]+([a-z]+)/i
        
        def self.register
            handler = Proc.new do |doc,src,context|
                # Deal with the first line
                if src.cur_line =~ CODE_BLOCK_WITH_LEXER
                    lang = $1
                else
                    lang = 'text'
                end
                src.shift_line

                # Read the source code block from the input
                lines = []
                while src.cur_line && !(src.cur_line =~ CODE_BLOCK)
                    lines.push src.shift_line
                end

                # Throw away the last line
                src.shift_line

                # Run it through the converter
                content = pygmentize lines.join($/), lang

                # Push it into the output and tell Maruku we handled it
                context.push doc.md_html content
                true
            end
            MaRuKu::In::Markdown.register_block_extension :regexp => CODE_BLOCK,
                                                          :handler => handler
        end
    end
end
SemiStatic::PygmentizeMarkdown.register
