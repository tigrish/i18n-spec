RSpec::Matchers.define :be_parseable do
  match do |actual|
    @locale_file = I18nSpec::LocaleFile.new(actual)
    @locale_file.is_parseable?
  end

  failure_meth = begin
                   method(:failure_message)
                 rescue NameError
                   method(:failure_message_for_should)
                 end

  failure_meth.call do |filepath|
    "expected #{filepath} to be parseable but got :\n- #{@locale_file.errors[:unparseable]}"
  end
end
