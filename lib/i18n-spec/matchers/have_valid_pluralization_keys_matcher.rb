RSpec::Matchers.define :have_valid_pluralization_keys do |expected|
  match do |actual|
    @locale_file = I18nSpec::LocaleFile.new(actual)
    @locale_file.invalid_pluralization_keys.empty?
  end

  failure_message_for_should do |filepath|
    "expected #{filepath} to not contain invalid pluralization keys in the following namespaces :\n- " << @locale_file.errors[:invalid_pluralization_keys].join("\n- ")
  end
end