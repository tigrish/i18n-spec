RSpec::Matchers.define :be_a_complete_translation_of do |default_locale_filepath, check_interpolation_key = false|
  extend I18nSpec::FailureMessage

  match do |filepath|
    locale_file = I18nSpec::LocaleFile.new(filepath)
    default_locale = I18nSpec::LocaleFile.new(default_locale_filepath)
    t1, t2 = default_locale.flattened_translations, locale_file.flattened_translations

    @missing_scopes = t1.keys - t2.keys

    if @missing_scopes.empty?
      if check_interpolation_key
        @missing_interpolation_keys = I18nSpec::InterpolationChecker.check t1, t2
        @missing_interpolation_keys.empty?
      else
        true
      end
    else
      false
    end
  end

  failure_for_should do |filepath|
    if @missing_interpolation_keys
      listed = @missing_interpolation_keys
        .map { |(scope, keys)| "\n - %s should have key %s" % [scope, keys.join(', ')] }
      "expected #{filepath} to contain the following interpolation keys :#{listed.join}"
    else
      "expected #{filepath} to include :\n- " << @missing_scopes.join("\n- ")
    end
  end
end
