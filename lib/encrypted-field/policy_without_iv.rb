# frozen_string_literal: true

require 'openssl'
require 'base64'

module EncryptedField
  # EncryptedField::PolicyWithoutIV all the logic required to encrypt/decrypt data using symmetric encryption.
  class PolicyWithoutIV < BasePolicy
    def encrypt(str)
      cipher = create_cipher.encrypt
      cipher.key = secret_key
      encode_payload(cipher.update(str) << cipher.final)
    end

    def decrypt(encrypted_str)
      cipher = create_cipher.decrypt
      cipher.key = secret_key
      cipher.update(decode_payload(encrypted_str)) << cipher.final
    end
  end
end
