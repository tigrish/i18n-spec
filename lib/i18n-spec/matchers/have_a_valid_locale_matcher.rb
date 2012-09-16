RSpec::Matchers.define :have_a_valid_locale do
  match do |actual|
    locale_file = I18nSpec::LocaleFile.new(actual)
    locale_file.locale.valid?
  end
end
