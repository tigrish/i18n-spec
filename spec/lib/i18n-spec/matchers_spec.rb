require 'spec_helper'

describe "Valid file" do
  it_behaves_like "a valid locale file", 'spec/fixtures/en.yml'
end

describe "Invalid files" do
  it { 'spec/fixtures/unparseable.yml'.should_not be_parseable }
  it { 'spec/fixtures/invalid_pluralization_keys.yml'.should_not have_valid_pluralization_keys }
  it { 'spec/fixtures/multiple_top_levels.yml'.should_not have_one_top_level_namespace }
  it { 'spec/fixtures/multiple_top_levels.yml'.should_not be_named_like_top_level_namespace }
  it { 'spec/fixtures/legacy_interpolations.yml'.should have_legacy_interpolations }
  it { 'spec/fixtures/not_subset.yml'.should_not be_a_subset_of 'spec/fixtures/en.yml' }
end

describe "Translated files" do
  describe 'spec/fixtures/fr.yml' do
    it { should be_a_subset_of 'spec/fixtures/en.yml' }
    it { should be_a_complete_translation_of 'spec/fixtures/en.yml' }
  end

  describe 'spec/fixtures/es.yml' do
    it { should be_a_subset_of 'spec/fixtures/en.yml' }
    it { should_not be_a_complete_translation_of 'spec/fixtures/en.yml'}
  end
end
