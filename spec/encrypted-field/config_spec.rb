require 'spec_helper'

describe EncryptedField::Config do
  let(:config) { EncryptedField::Config.instance }

  before do
    EncryptedField::Config.configure do
      algorithm = 'aes-256-cfb'
      secret_key = OpenSSL::Cipher.new(algorithm).random_key
      set_policy_separator '#'
      add_policy :default, algorithm, secret_key, '|'
    end
  end

  context 'policies' do
    subject { config.policies }

    it { expect(subject.size).to eq(1) }
    it { expect(subject['default'].nil?).to eq(false) }
    it { expect(subject[:default].nil?).to eq(true) }
  end

  context 'policy_separator_or_default' do
    subject { config.policy_separator_or_default }

    it { expect(subject).to eq('#') }

    describe 'default' do
      before { config.set_policy_separator(nil) }

      it { expect(subject).to eq('.') }
    end
  end

  context 'add_policy' do
    let(:policy_name) { :default }
    let(:algorithm) { 'aes-256-cfb' }
    let(:secret_key) { OpenSSL::Cipher.new(algorithm).random_key }
    let(:separator) { '.' }

    subject { config.add_policy(policy_name, algorithm, secret_key, separator) }

    it { expect { subject }.to_not raise_exception }

    describe 'policy_name contains policy_separator' do
      let(:policy_name) { 'my' + config.policy_separator_or_default + 'policy' }

      it { expect { subject }.to raise_error(RuntimeError) }
    end
  end
end
