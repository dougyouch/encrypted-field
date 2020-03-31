require 'spec_helper'

describe EncryptedField do
  let(:str) { 'this is a secret string ' + SecureRandom.uuid }
  let(:klass_name) { 'FakeClass' + SecureRandom.hex(6).upcase }
  let(:klass) do
    kls = Struct.new(:secret_encrypted) do
      include EncryptedField
      encrypted_field :secret, :default
    end
    Object.const_set(klass_name, kls)
    Object.const_get(klass_name)
  end

  before do
    EncryptedField::Config.configure do
      set_policy_separator '#'

      algorithm = 'aes-256-cfb'
      secret_key = Base64.strict_decode64('ykuU5P+CDo+n8g6QmAoT4dkbnifvWl3suBvQFvWExzc=')
      add_policy :default, algorithm, secret_key, '.'
    end

    klass
  end

  describe 'integration' do
    it 'encrypts/decrypts the data' do
      object1 = klass.new
      expect(object1.secret_encrypted.nil?).to eq(true)
      object1.secret = str
      expect(object1.secret_encrypted.nil?).to eq(false)

      object2 = klass.new(object1.secret_encrypted)
      expect(object2.secret).to eq(str)

      object1.secret = nil
      expect(object1.secret.nil?).to eq(true)
      expect(object1.secret_encrypted.nil?).to eq(true)
    end
  end
end
