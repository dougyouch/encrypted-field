[![Build Status](https://travis-ci.com/dougyouch/encrypted-field.svg?branch=master)](https://travis-ci.com/dougyouch/encrypted-field)
[![Maintainability](https://api.codeclimate.com/v1/badges/a11c2a2109f99622d677/maintainability)](https://codeclimate.com/github/dougyouch/encrypted-field/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/a11c2a2109f99622d677/test_coverage)](https://codeclimate.com/github/dougyouch/encrypted-field/test_coverage)

# encrypted-field

Simple way to encrypt/decrypt database fields.

## Installation

Add this line to your Gemfile:
```ruby
gem 'encrypted-field'
```

And then execute:
```shell
bundle
```

Or install it yourself as:
```shell
gem install encrypted-field
```

## Configuration

```ruby
EncryptedField::Config.configure do
  add_policy :default, 'aes-256-cfb', Base64.strict_decode64(ENV['ENCRYPTION_KEY'])
end
```

## ActiveRecord Field Encryption

Assuming table is
```sql
CREATE TABLE `api_creds` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password_encrypted` varchar(255) NOT NULL
)
```

Update ActiveRecord model with EncryptedField and specify the password as an encrypted field.
```ruby
class ApiCred < ActiveRecord::Base
  include EncryptedField

  encrypted_field :password, :default
end
```

## Workign With the Model

Convert plain text password to an encrypted value
```ruby
ApiCred.create!(
  name: 'Partner API Creds',
  username: 'user',
  password: 'DoN0TtELlAnYOne!'
)
```

Or use the setter
```ruby
api_cred = ApiCred.new
api_cred.password = 'DoN0TtELlAnYOne!'
```

To get back the plain text password
```ruby
api_cred = ApiCred.find(1)
api_cred.password
# => "DoN0TtELlAnYOne!"
```

## Custom Encrypted Field Name

## ActiveRecord Field Encryption

Assuming table is
```sql
CREATE TABLE `api_creds` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `custom_password_enc` varchar(255) NOT NULL
)
```

In the call encrypted_field specify the name of the DB field to store the encrypted value
```ruby
class ApiCred < ActiveRecord::Base
  include EncryptedField

  encrypted_field :password, :default, :custom_password_enc
end
```
