# i18n-spec

[![Build Status](https://secure.travis-ci.org/tigrish/i18n-spec.png)](http://travis-ci.org/tigrish/i18n-spec)

i18n-spec provides RSpec matchers for testing your locale files and their translations.

## Testing the validity of your locale files

There are a few matchers available; the subject of the spec is always a path to a locale file.

    describe "config/locales/en.yml" do
      it { should be_parseable }
      it { should have_valid_pluralization_keys }
      it { should_not have_missing_pluralization_keys }
      it { should have_one_top_level_namespace }
      it { should be_named_like_top_level_namespace }
      it { should_not have_legacy_interpolations }
      it { should have_a_valid_locale }
    end

All of these tests can be ran in one line with a shared example :

    describe "A locale file" do
      it_behaves_like 'a valid locale file', 'config/locales/en.yml'
    end

Even better, you can run all of these tests for every file in a directory like so :

    Dir.glob('config/locales/*.yml') do |locale_file|
      describe "a locale file" do
        it_behaves_like 'a valid locale file', locale_file
      end
    end

## Testing the validity of your translation data

To test that your locale file is a subset of the default locale file

	describe "config/locales/fr.yml" do
	  it { should be_a_subset_of 'config/locales/en.yml' }
	end

If you need to test that all translations have been completed :

    describe "config/locales/fr.yml" do
      it { should be_a_complete_translation_of 'config/locales/en.yml' }
    end

## Rake tasks

Include the tasks in your Rakefile with :

    require 'i18n-spec/tasks'

### Validating locale files

You can check a locale file with the following task :

    rake i18n-spec:validate FILEPATH

or check a whole directory :

    rake i18n-spec:validate DIRECTORY

### Checking for translation completeness


You can check a locale file with the following taks :

	rake i18n-spec:completeness SOURCE_FILEPATH TRANSLATED_FILEPATH

or again, check a whole directory :

	rake i18n-spec:completeness SOURCE_FILEPATH DIRECTORY
