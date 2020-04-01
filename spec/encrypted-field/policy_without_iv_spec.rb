require 'spec_helper'

describe EncryptedField::PolicyWithoutIV do
  let(:algorithm) { 'aes-256-cbc' }
  let(:secret_key) { Base64.strict_decode64('ykuU5P+CDo+n8g6QmAoT4dkbnifvWl3suBvQFvWExzc=') }
  let(:policy) { EncryptedField::PolicyWithoutIV.new(algorithm, secret_key) }
  let(:str) { 'This needs to be kept a secret' }
  let(:encrypted_str) { '5yKpSt838GyF1hsN1QY3+f0kd9hPLnOVgWyZEiTf6W0=' }

  context 'encrypt' do
    subject { policy.encrypt(str) }

    it { expect(subject).to eq(encrypted_str) }
  end

  context 'decrypt' do
    subject { policy.decrypt(encrypted_str) }

    it { expect(subject).to eq(str) }
  end

  describe 'secret_key as a proc' do
    let(:secret_key_proc) { Proc.new { secret_key } }
    let(:policy) { EncryptedField::PolicyWithoutIV.new(algorithm, secret_key_proc) }

    context 'decrypt' do
      subject { policy.decrypt(encrypted_str) }

      it { expect(subject).to eq(str) }
    end
  end
end
