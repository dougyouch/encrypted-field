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
      add_policy :policy1,
                 algorithm,
                 secret_key,
                 separator: '.',
                 encode_payload: lambda { |str| Base64.urlsafe_encode64(str) },
                 decode_payload: lambda { |str| Base64.urlsafe_decode64(str) },
                 encode_iv: lambda { |str| Base64.urlsafe_encode64(str) },
                 decode_iv: lambda { |str| Base64.urlsafe_decode64(str) }

      algorithm = 'aes-128-ctr'
      add_policy :policy2, algorithm, OpenSSL::Cipher.new(algorithm).random_key, separator: '|'

      algorithm = 'aes-256-cbc'
      add_policy_without_iv :policy3, algorithm, secret_key, prefix_with_policy_name: false
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

    describe 'without prefixing policy name' do
      let(:policy_name) { 'policy3' }

      it { expect(subject.include?('.')).to eq(false) }
      it { expect(subject.include?('#')).to eq(false) }
      it { expect(subject.start_with?('policy3#')).to eq(false) }
    end
  end

  context 'decrypt' do
    let(:str) { 'This needs to be kept a secret' }
    let(:encrypted_str) { 'policy1#lEogYLBi7K5SGNG1qpVfAQ==.8K5YpS8D6x0sEzSIcBJQV6fkwYzFqrAVMQe6U61L' }
    let(:fallback_policy_name) { nil }

    subject { encoder.decrypt(encrypted_str, fallback_policy_name) }

    it { expect(subject).to eq(str) }

    describe 'using fallback policy name' do
      let(:fallback_policy_name) { 'policy3' }

      it { expect(subject).to eq(str) }

      describe 'encrypted_str has no policy name associated to it' do
        let(:fallback_policy_name) { 'policy1' }
        let(:encrypted_str) { 'lEogYLBi7K5SGNG1qpVfAQ==.8K5YpS8D6x0sEzSIcBJQV6fkwYzFqrAVMQe6U61L' }

        it { expect(subject).to eq(str) }
      end
    end
  end
end
