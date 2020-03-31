require 'spec_helper'

describe EncryptedField::Field do
  let(:klass_name) { 'FakeClass' + SecureRandom.hex(6).upcase }
  let(:klass) do
    kls = Struct.new(:secret_encrypted) {}
    Object.const_set(klass_name, kls)
    Object.const_get(klass_name)
  end

  let(:field_name) { :secret }
  let(:encrypted_field_name) { :secret_encrypted }
  let(:policy_name) { :default }

  let(:field) { EncryptedField::Field.new(field_name, encrypted_field_name, policy_name) }

  context 'add_methods' do
    subject { field.add_methods(klass) }

    before { subject }

    it { expect(klass.instance_methods.include?(:secret)).to eq(true) }
    it { expect(klass.instance_methods.include?(:secret=)).to eq(true) }
  end

  describe 'integration' do
    let(:test_string) { 'this is a test string to encrypt ' + SecureRandom.uuid }

    before do
      EncryptedField::Config.configure do
        algorithm = 'aes-256-cfb'
        secret_key = OpenSSL::Cipher.new(algorithm).random_key
        add_policy :default, algorithm, secret_key
      end

      field.add_methods(klass)
    end

    it 'encrypts/decrypts the data' do
      object1 = klass.new
      expect(object1.secret_encrypted.nil?).to eq(true)
      object1.secret = test_string
      expect(object1.secret_encrypted.nil?).to eq(false)

      object2 = klass.new(object1.secret_encrypted)
      expect(object2.secret).to eq(test_string)

      object1.secret = nil
      expect(object1.secret.nil?).to eq(true)
      expect(object1.secret_encrypted.nil?).to eq(true)
    end
  end
end
