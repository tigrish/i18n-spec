RSpec::Matchers.define :be_a_complete_translation_of do |default_locale_filepath|
  extend I18nSpec::FailureMessage

  match do |filepath|
    locale_file = I18nSpec::LocaleFile.new(filepath)
    default_locale = I18nSpec::LocaleFile.new(default_locale_filepath)
    @misses = default_locale.flattened_translations.keys - locale_file.flattened_translations.keys
    @misses.empty?
  end

  failure_for_should do |filepath|
    "expected #{filepath} to include :\n- " << @misses.join("\n- ")
  end
end
