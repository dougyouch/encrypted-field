# frozen_string_literal: true

require 'rubygems'
require 'bundler'
require 'securerandom'
require 'simplecov'

SimpleCov.start

begin
  Bundler.require(:default, :spec)
rescue Bundler::BundlerError => e
  warn e.message
  warn 'Run `bundle install` to install missing gems'
  exit e.status_code
end

$LOAD_PATH.unshift(File.join(__dir__, '..', 'lib'))
$LOAD_PATH.unshift(__dir__)
require 'encrypted-field'

RSpec.configure do |config|
  config.after { EncryptedField::Config.instance.reset! }
end
