require 'spec_helper'

module LocaleFileHelper
  def locale_file_with_content(content)
    locale_file = I18nSpec::LocaleFile.new('test.yml')
    locale_file.should_receive(:content).and_return(content)
    locale_file
  end
end

describe I18nSpec::LocaleFile do
  include LocaleFileHelper

  describe "#is_parseable?" do
    context "when YAML is parseable" do
      let(:locale_file) { locale_file = locale_file_with_content("en:\n  hello: world") }

      it "returns true" do
        locale_file.is_parseable?.should == true
      end
    end

    context "when YAML is NOT parseable" do
      let(:locale_file) { locale_file_with_content("<This isn't YAML>: foo: bar:") }

      it "returns false" do
        locale_file.is_parseable?.should == false
      end

      it "adds an :unparseable error" do
        locale_file.is_parseable?
        locale_file.errors[:unparseable].should_not be_nil
      end
    end
  end

  describe "#pluralizations" do
    let(:content) {
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
          doves: doves"}

    it "returns the leaf where one of the keys is a pluralization key" do
      locale_file = locale_file_with_content(content)
      locale_file.pluralizations.should == {
        'en.cats' => {'one' => 'one', 'two' => 'two', 'three' => 'three'},
        'en.dogs' => {'one' => 'one', 'some' => 'some'},
      }
    end
  end

  describe "#invalid_pluralization_keys" do
    let(:content) {
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
          other: other"}
      let(:locale_file) { locale_file_with_content(content) }

    it "returns pluralization keys where key is not in PLURALIZATION_KEYS" do
      locale_file.invalid_pluralization_keys.should == ['en.cats.tommy', 'en.cats.tabby', 'en.dogs.some']
    end

    it "adds a :invalid_pluralization_keys error with each invalid key" do
      locale_file.invalid_pluralization_keys
      locale_file.errors[:invalid_pluralization_keys].should == ['en.cats.tommy', 'en.cats.tabby', 'en.dogs.some']
    end
  end
end