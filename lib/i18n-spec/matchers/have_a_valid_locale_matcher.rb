RSpec::Matchers.define :have_a_valid_locale do
  match do |actual|
    locale_file = I18nSpec::LocaleFile.new(actual)
    locale_file.has_a_valid_locale?
  end
end
