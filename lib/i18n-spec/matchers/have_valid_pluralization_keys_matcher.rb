RSpec::Matchers.define :have_valid_pluralization_keys do |expected|
  match do |actual|
    locale_file = I18nSpec::LocaleFile.new(actual)
    @invalid_keys = locale_file.invalid_pluralization_keys
    @invalid_keys.empty?
  end

  failure_message_for_should do |filepath|
    "expected #{filepath} to not include invalid pluralization keys :\n- " << @invalid_keys.join("\n- ")
  end
end