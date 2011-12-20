RSpec::Matchers.define :have_legacy_interpolations do |expected|
  match do |actual|
    locale_file = I18nSpec::LocaleFile.new(actual)
    locale_file.content =~ /{{.+}}/
  end
end
