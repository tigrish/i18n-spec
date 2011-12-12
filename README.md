# RSpec matchers for I18n files

i18n-spec provides RSpec matchers for testing your locale files.

## Implemented matchers

    describe "config/locales/en.yml" do
      it { should be_parseable }
      it { should have_valid_pluralization_keys }
    end

## To test all files in a specific directory

    Dir.glob('config/locales/*.yml') do |locale_file|
      describe locale_file do
        it { should be_parseable }
        it { should have_valid_pluralization_keys }
      end
    end

## TODO

    describe "config/locales/fr.yml" do
      it { should have_one_top_level_namespace }
      it { should be_named_after_the_top_level_namespace }
      it { should be_a_subset_of('config/locales/en.yml')
      it { should be_a_complete_translation_of('config/locales/en.yml') }
    end