RSpec::Matchers.define :have_interpolation_keys_of do |default_locale_filepath|
  extend I18nSpec::FailureMessage

  match do |test_locale_filepath|
    default_translations = I18nSpec::LocaleFile.new(default_locale_filepath).flat_interpolations_only_hash
    test_translations    = I18nSpec::LocaleFile.new(test_locale_filepath).flat_interpolations_only_hash

    @superset = default_translations.keys.reject do |key|
      default_value = default_translations[key]
      test_value    = test_translations[key]

      test_value.nil? ||
      I18nSpec::Parse.for_interpolation_variables(default_value) == I18nSpec::Parse.for_interpolation_variables(test_value)
    end

    @superset.empty?
  end

  failure_for_should do |filepath|
    "Expected #{filepath} interpolation variables to match #{default_locale_filepath}. \nProblems in:\n- " << @superset.join("\n- ")
  end
end
