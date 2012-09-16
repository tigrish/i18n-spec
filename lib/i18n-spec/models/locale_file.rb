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
      @translations ||= yaml_load_content
    end

    def flattened_translations
      @flattened_translations ||= flatten_tree(translations.values.first)
    end

    def locale
      @locale ||= ISO::Tag.new(locale_code)
    end

    def locale_code
      translations.keys.first
    end

    def pluralizations
      result = flatten_tree(translations).select do |key, value|
        value.is_a?(Hash)
      end

      if result.is_a?(Array)
        Hash[result]
      else
        result
      end
    end

    def invalid_pluralization_keys
      invalid = []
      pluralizations.each do |parent, pluralization|
        unless pluralization.keys.all? { |key| PLURALIZATION_KEYS.include?(key) }
          invalid << parent
        end
      end
      @errors[:invalid_pluralization_keys] = invalid unless invalid.empty?
      invalid
    end

    def is_parseable?
      begin
        yaml_load_content
        true
      rescue YAML::ParseError => e
        @errors[:unparseable] = e.to_s
        false
      rescue ArgumentError => e
        @errors[:unparseable] = e.to_s
        false
      end
    end

    def has_one_top_level_namespace?
      translations.keys.size == 1
    end

    def is_named_like_top_level_namespace?
      locale_code == File.basename(@filepath, File.extname(@filepath))
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

    def yaml_load_content
      if defined?(Psych) and defined?(Psych::VERSION)
        Psych.load(content)
      else
        YAML.load(content)
      end
    end

  end
end
