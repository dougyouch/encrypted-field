# frozen_string_literal: true

require 'openssl'
require 'base64'

module EncryptedField
  # EncryptedField::PolicyWithIV all the logic required to encrypt/decrypt data using symmetric encryption.
  class PolicyWithoutIV < BasePolicy
    def encrypt(str)
      cipher = create_cipher.encrypt
      cipher.key = secret_key
      Base64.strict_encode64(cipher.update(str) << cipher.final)
    end

    def decrypt(encrypted_str)
      cipher = create_cipher.decrypt
      cipher.key = secret_key
      cipher.update(Base64.strict_decode64(encrypted_str)) << cipher.final
    end
  end
end
