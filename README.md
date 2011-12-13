# i18n-spec

[![Build Status](https://secure.travis-ci.org/tigrish/i18n-spec.png)](http://travis-ci.org/tigrish/i18n-spec)

## RSpec matchers for I18n files

i18n-spec provides RSpec matchers for testing your locale files.

## Implemented matchers

    describe "config/locales/en.yml" do
      it { should be_parseable }
      it { should have_valid_pluralization_keys }
    end

All of these tests can be ran with a shared example :

    describe "A locale file" do
      it_behaves_like 'a valid locale file', 'config/locales/en.yml'
    end

You can run all of these tests for every file in a directory like so :

    Dir.glob('config/locale/*.yml') do |locale_file|
      describe "a locale file" do
        it_behaves_like 'a valid locale file', locale_file
      end
    end

## TODO

    describe "config/locales/fr.yml" do
      it { should have_one_top_level_namespace }
      it { should be_named_after_the_top_level_namespace }
      it { should be_a_subset_of('config/locales/en.yml')
      it { should be_a_complete_translation_of('config/locales/en.yml') }
    end