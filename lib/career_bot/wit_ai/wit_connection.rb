require 'wit'
require 'singleton'

class WitConnection
  include Singleton

  attr_reader :client

  def initialize
    access_token = ENV['WIT_ACCESS_TOKEN']
    actions = {
      send: -> (request, response) {
        if request['context']['testFunction']
          found_job_offer(request)
        else
          send_response(request, response)
        end
      },
      get_job: -> (request) {
        context = request['context']
        entities = request['entities']

        context['testFunction'] = first_entity_value(entities, 'position')
        return context
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
        return context
      }
    }
    @client = Wit.new(access_token: access_token, actions: actions)
  end

  private

  def send_response(request, response)
    text_response = {
      text: response['text']
    }
    bot_deliver(request, text_response)
  end

  def found_job_offer(request)
    key_word = request['context']['testFunction']
    @data = JobService.new(key_word).get_jobs

    bot_deliver(request, { text: message })
    bot_deliver(request, { attachment: GenericTemplate.new(attachment).to_hash })
    bot_deliver(request, { text: 'Found anything interesting? If not, you can try again! Or maybe you want to play a game now? :)' })
  end

  def first_entity_value(entities, entity)
    return unless entities.has_key? entity
    val = entities[entity][0]['value']
    return if val.nil?
    return val.is_a?(Hash) ? val['value'] : val
  end

  def bot_deliver(request, text_response)
    Bot.deliver(
      {
        recipient:
          {
            id: request['session_id']
          },
        message: text_response
      }, access_token: ENV['ACCESS_TOKEN']
    )
  end

  def attachment
    @data.any? ? @data : WorkableService.new.get_active_jobs

  end

  def message
    if @data.any?
      'Yay! :) We have something you may be interested in! Check this out!'
    else
      "Unfortunately we don't have any matching job offers :( buuuut... you can still check out all of our open positions!"
    end
  end
end
