RSpec::Matchers.define :be_a_complete_translation_of do |expected|
  match do |actual|
    locale_file = I18nSpec::LocaleFile.new(actual)
    locale_file.is_a_complete_tranlsation_of? expected
  end
end