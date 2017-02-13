require 'wit'
require 'singleton'

class WitConnection
  include Singleton

  attr_reader :client

  def initialize
    @client = Wit.new(access_token: access_token, actions: actions)
  end

  private

  def access_token
    ENV['WIT_ACCESS_TOKEN']
  end

  def actions
    WitActionsService.new.wit_actions
  end
end
