# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.

if Rails.env.production? && ENV['SECRET_TOKEN'].blank?
  raise 'SECRET_TOKEN environment variable must be set!'
end

Emonweb::Application.config.secret_token = ENV['SECRET_TOKEN'] || '2b6d84e6f6554eeabf53fd3a8531cf55bd3c0b51b91db0b1c096d7fc2eb7d2f6b4cfd3c484f77d99f824bf2e353ae15832d59b6630a62ed997577c9a8e9a199e'
