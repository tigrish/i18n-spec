RSpec::Matchers.define :be_a_subset_of do |default_locale_filepath|
  match do |filepath|
    locale_file = I18nSpec::LocaleFile.new(filepath)
    default_locale = I18nSpec::LocaleFile.new(default_locale_filepath)
    @superset = locale_file.flattened_translations.keys.reject do |key|
      default_locale.flattened_translations.keys.include?(key)
    end
    @superset.empty?
  end

  failure_meth = begin
                   method(:failure_message)
                 rescue NameError
                   method(:failure_message_for_should)
                 end

  failure_meth.call do |filepath|
    "expected #{filepath} to not include :\n- " << @superset.join("\n- ")
  end
end
