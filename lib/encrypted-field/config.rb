# frozen_string_literal: true

require 'singleton'

module EncryptedField
  # EncryptedField::Config keeps track of all policies and the policy separator
  class Config
    include Singleton

    POLICY_DEFAULT_SEPARATOR = '.'

    attr_reader :policy_separator

    def policies
      @policies ||= {}
    end

    def set_policy_separator(policy_separator)
      @policy_separator = policy_separator
    end

    def policy_separator_or_default
      policy_separator || POLICY_DEFAULT_SEPARATOR
    end

    def add_policy(policy_name, algorithm, secret_key, options = {})
      if invalid_policy_name?(policy_name)
        raise("policy name #{policy_name} can not include \"#{policy_separator_or_default}\"")
      end

      add_custom_policy(policy_name, PolicyWithIV.new(algorithm, secret_key, options))
    end

    def add_custom_policy(policy_name, policy)
      policies[policy_name.to_s] = policy
    end

    def self.configure(&block)
      instance.instance_eval(&block)
    end

    def reset!
      @policies = nil
      @policy_separator = nil
    end

    def invalid_policy_name?(policy_name)
      policy_name.to_s.include?(policy_separator_or_default)
    end
  end
end
