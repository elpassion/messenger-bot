require 'wit'
require 'singleton'

class WitConnection
  include Singleton

  attr_reader :client

  def initialize
    access_token = ENV['WIT_ACCESS_TOKEN']
    actions = {
      send: ->(request, response) { send_response(request, response) }
    }
    @client = Wit.new(access_token: access_token, actions: actions)
  end

  private

  def send_response(request, response)
    Bot.deliver(
      {
        recipient:
          {
            id: request['session_id']
          },
        message: {
          text: response['text']
        }
      }, access_token: ENV['ACCESS_TOKEN']
    )
  end
end
