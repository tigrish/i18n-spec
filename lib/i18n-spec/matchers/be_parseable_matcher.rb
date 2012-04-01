RSpec::Matchers.define :be_parseable do
  match do |actual|
    @locale_file = I18nSpec::LocaleFile.new(actual)
    @locale_file.is_parseable?
  end

  failure_message_for_should do |filepath|
    "expected #{filepath} to be parseable but got :\n- #{@locale_file.errors[:unparseable]}"
  end
end