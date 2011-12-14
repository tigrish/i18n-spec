RSpec::Matchers.define :be_named_like_top_level_namespace do |expected|
  match do |actual|
    locale_file = I18nSpec::LocaleFile.new(actual)
    locale_file.is_named_like_top_level_namespace?
  end
end