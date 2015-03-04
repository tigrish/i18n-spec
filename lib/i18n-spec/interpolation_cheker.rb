module I18nSpec
  module InterpolationChecker
    class << self

      def check(t1, t2)
        k1, k2 = list_interpolation_keys(t1), list_interpolation_keys(t2)
        missing_keys = {}

        k1.each do |(scope, keys)|
          next unless k2.respond_to? :[]
          diff = keys - (k2[scope] || [])
          missing_keys[scope] = diff unless diff.empty?
        end

        missing_keys
      end

      def list_interpolation_keys(t, scopes = [], result = {})
        if t.is_a? Hash
          t.each do |(k, v)|
            list_interpolation_keys v, [*scopes, k], result
          end
        elsif t.is_a? Array
          t.each_with_index do |v, i|
            list_interpolation_keys v, [*scopes, i], result
          end
        else
          keys = extract_interpolation_keys t
          result[scopes.join('.')] = keys unless keys.empty?
        end

        result
      end

      def extract_interpolation_keys(translation)
        translation.to_s.scan(/(?<!%)%\{([^\}]+)\}/).flatten
      end

    end
  end
end
