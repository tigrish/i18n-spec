RSpec::Matchers.define :have_valid_pluralization_keys do |expected|
  match do |actual|
    locale_file = I18nSpec::LocaleFile.new(actual)
    locale_file.has_valid_pluralization_keys?
  end
end