require 'spec_helper'

describe EncryptedField::PolicyWithIV do
  let(:algorithm) { 'aes-256-cfb' }
  let(:secret_key) { Base64.strict_decode64('ykuU5P+CDo+n8g6QmAoT4dkbnifvWl3suBvQFvWExzc=') }
  let(:separator) { EncryptedField::PolicyWithIV::DEFAULT_SEPARATOR }
  let(:policy) { EncryptedField::PolicyWithIV.new(algorithm, secret_key, separator: separator) }
  let(:str) { 'This needs to be kept a secret' }
  let(:encrypted_str) { 'lEogYLBi7K5SGNG1qpVfAQ==.8K5YpS8D6x0sEzSIcBJQV6fkwYzFqrAVMQe6U61L' }

  context 'encrypt' do
    subject { policy.encrypt(str) }

    it { expect(subject.include?(separator)).to eq(true) }
    # using a random_iv it should not produce the same encrypted string twice
    it { expect(subject).to_not eq(encrypted_str) }
  end

  context 'decrypt' do
    subject { policy.decrypt(encrypted_str) }

    it { expect(subject).to eq(str) }
  end

  describe 'secret_key as a proc' do
    let(:secret_key_proc) { Proc.new { secret_key } }
    let(:policy) { EncryptedField::PolicyWithIV.new(algorithm, secret_key_proc, separator: separator) }

    context 'decrypt' do
      subject { policy.decrypt(encrypted_str) }

      it { expect(subject).to eq(str) }
    end
  end
end
