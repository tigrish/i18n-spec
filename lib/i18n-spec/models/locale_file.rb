module I18nSpec
  class LocaleFile
    PLURALIZATION_KEYS = %w{zero one two few many other}

    attr_accessor :filepath

    def initialize(filepath)
      @filepath = filepath
    end

    def translations
      @translations ||= Psych.load_file(@filepath)
    end

    def flattened_translations
      @flattened_translations ||= flatten_tree(translations.values.first)
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

    def is_named_like_top_level_namespace?
      translations.keys.first == File.basename(@filepath, File.extname(@filepath))
    end

    def is_a_complete_tranlsation_of?(default_locale_filepath)
      default_locale = LocaleFile.new(default_locale_filepath)
      default_keys   = flatten_tree(translations.values.first).keys.sort
      keys           = flatten_tree(default_locale.translations.values.first).keys.sort
      keys == default_keys
    end

  protected

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