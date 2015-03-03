RSpec::Matchers.define :be_a_complete_interpolation_key_of do |default_locale_filepath|
  extend I18nSpec::FailureMessage

  match do |filepath|
    locale_file = I18nSpec::LocaleFile.new(filepath)
    default_locale = I18nSpec::LocaleFile.new(default_locale_filepath)

    @missings = {}

    check_interpolation default_locale.flattened_translations, locale_file.flattened_translations do |scope, keys|
      @missings[scope] = keys
    end

    @missings.empty?
  end

  def check_interpolation(t1, t2, scopes = [], &block)
    if t1.is_a? Hash
      t1.each do |(k, v)|
        check_interpolation v, t2[k], [*scopes, k], &block
      end
    elsif t2.is_a? Array
      t1.each_with_index do |v, i|
        scopes << i
        check_interpolation v, t2[i], [*scopes, k], &block
      end
    else
      k1 = get_interpolation_keys t1
      k2 = get_interpolation_keys t2
      keys = (k1 - k2) | (k2 - k1)
      yield scopes.join('.'), keys unless keys.empty?
    end
  end

  def get_interpolation_keys(translation)
    translation.to_s.scan(/(?<!%)%\{([^\}]+)\}/).flatten
  end

  failure_for_should do |filepath|
    listed = @missings.map { |(scope, keys)| "\n - %s should have key %s" % [scope, keys.join(', ')] }
    "expected #{filepath} to contain the following interpolation keys :#{listed.join}"
  end
end
