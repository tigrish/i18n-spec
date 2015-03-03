require 'spec_helper'

describe "Valid file" do
  it_behaves_like "a valid locale file", 'spec/fixtures/en.yml'
end

describe "Invalid files" do
  it { expect('spec/fixtures/unparseable.yml').not_to be_parseable }
  it { expect('spec/fixtures/invalid_pluralization_keys.yml').not_to have_valid_pluralization_keys }
  it { expect('spec/fixtures/multiple_top_levels.yml').not_to have_one_top_level_namespace }
  it { expect('spec/fixtures/multiple_top_levels.yml').not_to be_named_like_top_level_namespace }
  it { expect('spec/fixtures/legacy_interpolations.yml').to have_legacy_interpolations }
  it { expect('spec/fixtures/invalid_locale.yml').not_to have_a_valid_locale }
  it { expect('spec/fixtures/not_subset.yml').not_to be_a_subset_of 'spec/fixtures/en.yml' }
  it { expect('spec/fixtures/missing_pluralization_keys.yml').to have_missing_pluralization_keys }
end

describe "Translated files" do
  describe 'spec/fixtures/fr.yml' do
    it { is_expected.to be_a_subset_of 'spec/fixtures/en.yml' }
    it { is_expected.to be_a_complete_translation_of 'spec/fixtures/en.yml' }
  end

  describe 'spec/fixtures/es.yml' do
    it { is_expected.to be_a_subset_of 'spec/fixtures/en.yml' }
    it { is_expected.not_to be_a_complete_translation_of 'spec/fixtures/en.yml'}
  end
end

describe 'Interpolation keys' do
  describe 'spec/fixtures/fr.yml' do
    it { is_expected.to be_a_complete_interpolation_key_of 'spec/fixtures/en.yml' }
  end

  describe 'spec/fixtures/es.yml' do
    it { is_expected.not_to be_a_complete_interpolation_key_of 'spec/fixtures/en.yml' }
  end
end
