RSpec::Matchers.define :have_valid_pluralization_keys do
  match do |actual|
    @locale_file = I18nSpec::LocaleFile.new(actual)
    @locale_file.invalid_pluralization_keys.empty?
  end

  failure_meth = begin
                   method(:failure_message)
                 rescue NameError
                   method(:failure_message_for_should)
                 end

  failure_meth.call do |filepath|
    "expected #{filepath} to not contain invalid pluralization keys in the following namespaces :\n- " << @locale_file.errors[:invalid_pluralization_keys].join("\n- ")
  end
end
