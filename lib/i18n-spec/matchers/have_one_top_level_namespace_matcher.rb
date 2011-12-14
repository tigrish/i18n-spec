RSpec::Matchers.define :have_one_top_level_namespace do |expected|
  match do |actual|
    locale_file = I18nSpec::LocaleFile.new(actual)
    locale_file.has_one_top_level_namespace?
  end
end