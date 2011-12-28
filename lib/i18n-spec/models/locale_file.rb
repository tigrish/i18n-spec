module I18nSpec
  class LocaleFile
    PLURALIZATION_KEYS = %w{zero one two few many other}

    attr_accessor :filepath
    attr_reader :errors

    def initialize(filepath)
      @filepath = filepath
      @errors = {}
    end

    def content
      @content ||= IO.read(@filepath)
    end

    def translations
      @translations ||= Psych.load(content)
    end

    def flattened_translations
      @flattened_translations ||= flatten_tree(translations.values.first)
    end

    def pluralizations
      flatten_tree(translations).select do |key, value|
        value.is_a?(Hash)
      end
    end

    def invalid_pluralization_keys
      invalid = []
      pluralizations.each do |parent, pluralization|
        pluralization.keys.select do |key, value|
          invalid << [parent, key].join('.') unless PLURALIZATION_KEYS.include?(key)
        end
      end
      @errors[:invalid_pluralization_keys] = invalid unless invalid.empty?
      invalid
    end

    def is_parseable?
      begin
        Psych.load(content)
        true
      rescue Psych::SyntaxError => e
        @errors[:unparseable] = e.to_s
        false
      end
    end

    def has_one_top_level_namespace?
      translations.keys.size == 1
    end

    def is_named_like_top_level_namespace?
      translations.keys.first == File.basename(@filepath, File.extname(@filepath))
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

  end
end
