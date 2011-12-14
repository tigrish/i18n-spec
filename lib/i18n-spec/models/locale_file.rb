module I18nSpec
  class LocaleFile
    PLURALIZATION_KEYS = %w{zero one two few many other}

    def initialize(filepath)
      @filepath = filepath
    end

    def is_parseable?
      begin
        Psych.load_file(@filepath)
        true
      rescue Psych::SyntaxError => e
        false
      end
    end

    def has_valid_pluralization_keys?
      pluralizations.each do |key, pluralization|
        return false unless pluralization.keys.all? {|k| PLURALIZATION_KEYS.include?(k)}
      end
      true
    end

    def has_one_top_level_namespace?
      translations.keys.size == 1
    end

  protected

    def translations
      @translations ||= Psych.load_file(@filepath)
    end

    def flatten_tree(data, prefix = '', result = {})
      data.each do |key, value|
        current_prefix = prefix.empty? ? key.to_s : "#{prefix}.#{key}"
        if !value.is_a?(Hash) || pluralization_data?(value)
          result[current_prefix] = value
        else
          flatten_tree(value, current_prefix, result)
        end
      end
      result
    end

    def pluralization_data?(data)
      keys = data.keys.map(&:to_s)
      keys.any? {|k| PLURALIZATION_KEYS.include?(k) }
    end

    def pluralizations
      flatten_tree(translations).select do |key, value|
        value.is_a?(Hash)
      end
    end
  end
end