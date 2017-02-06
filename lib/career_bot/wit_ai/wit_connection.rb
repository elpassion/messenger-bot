require 'wit'
require 'singleton'

class WitConnection
  include Singleton

  attr_reader :client

  def initialize
    access_token = ENV['WIT_ACCESS_TOKEN']
    actions = {
      send: -> (request, response) {
        context = request['context']['testFunction']

        WitResponseService.new(context, request['session_id'], response).send_response
      },
      get_job: -> (request) {
        context = request['context']
        entities = request['entities']

        context['testFunction'] = first_entity_value(entities, 'position')
        context
      },
      play_game: -> (request) {
        context = request['context']
        entities = request['entities']

        number = first_entity_value(entities, 'number')
        if number.nil?
          context['wrongParam'] = true
        else
          context['lost'] = first_entity_value(entities, 'number') + 1
          context['number'] = number + 1
        end
        context
      }
    }
    @client = Wit.new(access_token: access_token, actions: actions)
  end

  private

  def first_entity_value(entities, entity)
    return unless entities.has_key? entity
    val = entities[entity][0]['value']
    return if val.nil?
    return val.is_a?(Hash) ? val['value'] : val
  end
end
