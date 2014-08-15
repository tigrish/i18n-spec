RSpec::Matchers.define :have_interpolation_keys_of do |default_locale_filepath|
  extend I18nSpec::FailureMessage

  match do |filepath|
    locale_file = I18nSpec::LocaleFile.new(filepath)
    default_locale = I18nSpec::LocaleFile.new(default_locale_filepath)

    @superset = locale_file.flattened_and_interpolation_only.keys.reject do |key|

      default_vars = default_locale.flattened_and_interpolation_only[key]
      locale_vars  =    locale_file.flattened_and_interpolation_only[key]

      (locale_vars == default_vars) || locale_vars.empty?
    end

    @superset.empty?
  end

  failure_for_should do |filepath|
    "Expected #{filepath} interpolation variables to match #{default_locale_filepath}. \nProblems in:\n- " << @superset.join("\n- ")
  end
end
