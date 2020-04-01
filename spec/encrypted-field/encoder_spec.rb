require 'spec_helper'

describe EncryptedField::Encoder do
  let(:policy_name) { 'policy1' }
  let(:str) { 'this is a secret string ' + SecureRandom.uuid }
  let(:encoder) { EncryptedField::Encoder.new }

  before do
    EncryptedField::Config.configure do
      set_policy_separator '#'

      algorithm = 'aes-256-cfb'
      secret_key = Base64.strict_decode64('ykuU5P+CDo+n8g6QmAoT4dkbnifvWl3suBvQFvWExzc=')
      add_policy :policy1, algorithm, secret_key, separator: '.'

      algorithm = 'aes-128-ctr'
      add_policy :policy2, algorithm, OpenSSL::Cipher.new(algorithm).random_key, separator: '|'
    end
  end

  context 'encrypt' do
    subject { encoder.encrypt(str, policy_name) }

    it { expect(subject.include?('.')).to eq(true) }
    it { expect(subject.start_with?('policy1#')).to eq(true) }

    describe 'different policy' do
      let(:policy_name) { 'policy2' }

      it { expect(subject.include?('.')).to eq(false) }
      it { expect(subject.include?('|')).to eq(true) }
      it { expect(subject.start_with?('policy2#')).to eq(true) }
    end
  end

  context 'decrypt' do
    let(:str) { 'This needs to be kept a secret' }
    let(:encrypted_str) { 'policy1#lEogYLBi7K5SGNG1qpVfAQ==.8K5YpS8D6x0sEzSIcBJQV6fkwYzFqrAVMQe6U61L' }

    subject { encoder.decrypt(encrypted_str) }

    it { expect(subject).to eq(str) }
  end
end
