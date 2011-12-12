RSpec::Matchers.define :be_parseable do |expected|
  match do |actual|
    locale_file = I18nSpec::LocaleFile.new(actual)
    locale_file.is_parseable?
  end
end