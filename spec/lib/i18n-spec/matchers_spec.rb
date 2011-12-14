require 'spec_helper'

describe "Valid file" do
  it_behaves_like "a valid locale file", 'spec/fixtures/en.yml'
end

describe "Invalid files" do
  it { 'spec/fixtures/unparseable.yml'.should_not be_parseable }
  it { 'spec/fixtures/invalid_pluralization_keys.yml'.should_not have_valid_pluralization_keys }
  it { 'spec/fixtures/multiple_top_levels.yml'.should_not have_one_top_level_namespace }
end