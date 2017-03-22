# Configure your routes here
# See: http://hanamirb.org/guides/routing/overview/
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }

mount Facebook::Messenger::Server, at: 'bot'

get '/docs/privacy_policy', to: 'docs#privacy_policy'
