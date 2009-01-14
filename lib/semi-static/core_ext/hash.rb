module SemiStatic
    module CoreExt
        module Hash
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

class Hash
    include SemiStatic::CoreExt::Hash
end
