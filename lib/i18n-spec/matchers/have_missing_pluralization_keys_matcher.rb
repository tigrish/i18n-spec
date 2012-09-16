RSpec::Matchers.define :have_missing_pluralization_keys do
  match do |actual|
    @locale_file = I18nSpec::LocaleFile.new(actual)
    @locale_file.missing_pluralization_keys.any?
  end

  failure_message_for_should_not do |filepath|
    flattened_keys = []

    @locale_file.errors[:missing_pluralization_keys].each do |parent, subkeys|
      subkeys.each do |subkey|
        flattened_keys << [parent, subkey].join('.')
      end
    end

    "expected #{filepath} to contain the following pluralization keys :\n- " << flattened_keys.join("\n- ")
  end
end
