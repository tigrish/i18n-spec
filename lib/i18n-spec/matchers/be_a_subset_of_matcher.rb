RSpec::Matchers.define :be_a_subset_of do |expected|
  match do |actual|
    @locale_file = I18nSpec::LocaleFile.new(actual)
    @default_locale = I18nSpec::LocaleFile.new(expected)
    @superset = @locale_file.flattened_translations.keys.reject do |key|
      @default_locale.flattened_translations.keys.include?(key)
    end
    @superset.empty?
  end

  failure_message_for_should do |player|
    "expected #{@locale_file.filepath} to not include :\n- " << @superset.join("\n- ")#{@superset.join"
  end
end