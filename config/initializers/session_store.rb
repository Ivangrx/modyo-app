# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_modyo-app_session',
  :secret      => 'dac77157e7ce44c7df1825366429d0f51da59144051018df3741808c5677a9e1e6df11af87b274a1c963efc12e1a0321842c7ebb927d0abe85fcf1321d6aea7c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
