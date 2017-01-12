require 'wit'
require 'singleton'

class WitConnection
  include Singleton

  attr_reader :client

  def initialize
    access_token = ENV['WIT_ACCESS_TOKEN']
    actions = {
      send: -> (request, response) {
        found_job_offer(request, response)
      },
      get_job: -> (request) {
        context = request['context']
        entities = request['entities']

        context['testFunction'] = first_entity_value(entities, 'position')
        return context
      }
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

  def found_job_offer(request, response)
    key_word = request['context']['testFunction']
    data = JobService.new(key_word).get_jobs
    Bot.deliver(
      {
        recipient:
          {
            id: request['session_id']
          },
        message: {
          attachment: data.any? ? GenericTemplate.new(data).to_hash : GenericTemplate.new(WorkableService.new.get_active_jobs).to_hash
        }
      }, access_token: ENV['ACCESS_TOKEN']
    )
  end

  def first_entity_value(entities, entity)
    return unless entities.has_key? entity
    val = entities[entity][0]['value']
    return if val.nil?
    return val.is_a?(Hash) ? val['value'] : val
  end
end
