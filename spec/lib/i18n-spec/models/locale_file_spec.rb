require 'spec_helper'

describe I18nSpec::LocaleFile, "#pluralizations" do
  def content
    "en:
      cats:
        one: one
        two: two
        three: three
      dogs:
        one: one
        some: some
      birds:
        penguins: penguins
        doves: doves"
  end

  it "returns the leaf where one of the keys is a pluralization key" do
    locale_file = I18nSpec::LocaleFile.new('test.yml')
    locale_file.should_receive(:content).and_return(content)
    locale_file.pluralizations.should == {
      'en.cats' => {'one' => 'one', 'two' => 'two', 'three' => 'three'},
      'en.dogs' => {'one' => 'one', 'some' => 'some'},
    }
  end
end

describe I18nSpec::LocaleFile, "#invalid_pluralization_keys" do
  def content
    "en:
      cats:
        one: one
        two: two
        tommy: tommy
        tabby: tabby
      dogs:
        one: one
        some: some
      birds:
        zero: zero
        other: other"
  end

  it "returns pluralization keys where key is not in PLURALIZATION_KEYS" do
    locale_file = I18nSpec::LocaleFile.new('test.yml')
    locale_file.should_receive(:content).and_return(content)
    locale_file.invalid_pluralization_keys.should == ['en.cats.tommy', 'en.cats.tabby', 'en.dogs.some']
  end
end