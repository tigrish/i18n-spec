RSpec::Matchers.define :be_a_subset_of do |default_locale_filepath|
  extend I18nSpec::FailureMessage

  match do |filepath|
    locale_file = I18nSpec::LocaleFile.new(filepath)
    default_locale = I18nSpec::LocaleFile.new(default_locale_filepath)
    @superset = locale_file.flattened_translations.keys.reject do |key|
      default_locale.flattened_translations.keys.include?(key)
    end
    @superset.empty?
  end

  failure_for_should do |filepath|
    "expected #{filepath} to not include :\n- " << @superset.join("\n- ")
  end
end
