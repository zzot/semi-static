module SemiStatic
    module CoreExt #:nodoc:
        module Hash
            # Replace self with a hash whose keys have been converted to symbols.
            def symbolize_keys
                hash = to_a.inject({}) do |memo,item|
                    key, value = item
                    memo[key.to_sym] = value
                    memo
                end
                replace(hash)
            end
        end
    end
end

class Hash #:nodoc:
    include SemiStatic::CoreExt::Hash
end
