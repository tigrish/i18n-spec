require 'spec_helper'

describe "spec/fixtures/en.yml" do
  it { should be_parseable }
  it { should have_valid_pluralization_keys }
end

describe "Invalid files" do
  it { 'spec/fixtures/unparseable.yml'.should_not be_parseable }
  it { 'spec/fixtures/invalid_pluralization_keys.yml'.should_not have_valid_pluralization_keys }
end