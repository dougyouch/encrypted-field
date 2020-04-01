# frozen_string_literal: true

module EncryptedField
  # EncryptedField::Encoder prepends the policy name to the encrypted string
  class Encoder
    class << self
      attr_writer :encoder

      def encoder
        @encoder ||= Encoder.new
      end
    end

    def encrypt(str, policy_name)
      policy_name.dup << policy_separator << get_policy(policy_name).encrypt(str)
    end

    def decrypt(encrypted_str_with_policy_name)
      policy_name, encrypted_str = encrypted_str_with_policy_name.split(policy_separator, 2)
      get_policy(policy_name).decrypt(encrypted_str)
    end

    private

    def config
      Config.instance
    end

    def policy_separator
      config.policy_separator_or_default
    end

    def get_policy(policy_name)
      config.policies[policy_name] || raise("missing policy #{policy_name}")
    end
  end
end
