require 'wit'
require 'singleton'

class WitConnection
  include Singleton

  attr_reader :client

  def initialize
    @client = Wit.new(access_token: access_token, actions: actions)
  end

  private

  def actions
    {
      send: -> (request, response) {
        context = request['context']['job_position']

        WitResponseService.new(context, request['session_id'], response).send_response
      },
      get_job: -> (request) {
        context = request['context']

        context['job_position'] = first_entity_value(request['entities'], 'position')
        context
      },
      play_game: -> (request) {
        context = request['context']

        number = first_entity_value(request['entities'], 'number')
        if number.nil?
          context['wrongParam'] = true
        else
          context['lost'] = true
          context['number'] = number + 1
        end
        context
      }
    }
  end

  def access_token
    ENV['WIT_ACCESS_TOKEN']
  end

  def first_entity_value(entities, entity)
    entities[entity][0]['value'] if entities.has_key? entity
  end
end
