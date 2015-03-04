require 'spec_helper'

describe I18nSpec::InterpolationChecker do

  describe '::extract_interpolation_keys' do

    it 'should extract interpolation keys' do
      text = 'non_key %{key_1} {non_key} %{key_2}'
      keys = %w[key_1 key_2]

      expect(I18nSpec::InterpolationChecker.extract_interpolation_keys(text)).to eq keys
    end

    it 'should not extract keys of interpolation-like syntax with escaped %' do
      text = '%{key} %%{non_key}'
      non_key = 'non_key'

      expect(I18nSpec::InterpolationChecker.extract_interpolation_keys(text)).not_to include non_key
    end

  end

  describe '::list_interpolation_keys' do

    it 'should return pairs of scope and interpolation keys' do
      translations = {
        a: { aa: '%{a_aa_key}', ab: '%{a_ab_key}' },
        b: { ba: '%{b_ba_key}' },
        c: [{ ca: '%{c_0_ca_key}' }],
      }

      keys = {
        'a.aa'   => %w[a_aa_key],
        'a.ab'   => %w[a_ab_key],
        'b.ba'   => %w[b_ba_key],
        'c.0.ca' => %w[c_0_ca_key],
      }

      expect(I18nSpec::InterpolationChecker.list_interpolation_keys(translations)).to eq keys
    end

  end

  describe '::check' do

    it 'should return an empty hash if interpolation keys are fully contained in both key lists' do
      t1 = {
        a: { aa: '%{a_aa_key}', ab: '%{a_ab_key}' },
        b: { ba: '%{b_ba_key}' },
        c: [{ ca: '%{c_0_ca_key}' }],
      }
      t2 = {
        a: { aa: '%{a_aa_key}', ab: '%{a_ab_key}' },
        b: { ba: '%{b_ba_key}' },
        c: [{ ca: '%{c_0_ca_key}' }],
      }

      expect(I18nSpec::InterpolationChecker.check(t1, t2)).to eq({})
    end

    it 'should return a hash of missing translations keys if interpolation keys are not fully contained in both key lists' do
      t1 = {
        a: { aa: '%{a_aa_key}', ab: '%{a_ab_key}' },
        b: { ba: '%{b_ba_key}' },
        c: [{ ca: '%{c_0_ca_key}' }],
      }
      t2 = {
        a: { aa: '%{a_aa_key}', ab: '%{a_ab_k3y}' },
        b: { ba: '' },
        c: [{ ca: '%{c_0_ca_key}' }],
      }

      keys = {
        'a.ab' => %w[a_ab_key],
        'b.ba' => %w[b_ba_key],
      }

      expect(I18nSpec::InterpolationChecker.check(t1, t2)).to eq keys
    end

  end

end
