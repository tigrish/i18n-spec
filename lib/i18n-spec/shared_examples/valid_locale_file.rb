shared_examples_for "a valid locale file" do |locale_file|
  describe locale_file do
    it { should be_parseable }
    it { should have_valid_pluralization_keys }
  end
end