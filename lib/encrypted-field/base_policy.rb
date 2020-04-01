# frozen_string_literal: true

require 'openssl'
require 'base64'

module EncryptedField
  # EncryptedField::BasePolicy abstract class for creating encryption policies
  class BasePolicy
    attr_reader :algorithm,
                :options

    def initialize(algorithm, secret_key, options = {})
      @algorithm = algorithm
      @secret_key = secret_key
      @options = options
    end

    def prefix_with_policy_name?
      options.fetch(:prefix_with_policy_name, true)
    end

    private

    def encode_payload(str)
      Base64.strict_encode64(str)
    end

    def decode_payload(str)
      Base64.strict_decode64(str)
    end

    def encode_iv(str)
      Base64.strict_encode64(str)
    end

    def decode_iv(str)
      Base64.strict_decode64(str)
    end

    def create_cipher
      OpenSSL::Cipher.new(algorithm)
    end

    def secret_key
      case @secret_key
      when Proc
        @secret_key.call
      when String
        @secret_key
      end
    end
  end
end
