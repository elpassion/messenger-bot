class WitActionsService
  def wit_actions
    [send, get_job, play_game].reduce(:merge)
  end

  private

  def send
    {
      send: -> (request, response) {
        context = request['context']['job_position']

        WitResponseService.new(context, request['session_id'], response).send_response
      }
    }
  end

  def get_job
    {
      get_job: -> (request) {
        context = request['context']

        context['job_position'] = first_entity_value(request['entities'], 'position')
        context
      }
    }
  end

  def play_game
    {
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

  def first_entity_value(entities, entity)
    entities[entity][0]['value'] if entities.has_key? entity
  end
end
