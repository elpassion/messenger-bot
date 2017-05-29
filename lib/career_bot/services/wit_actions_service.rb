class WitActionsService
  def wit_actions
    send.merge(wit_methods)
  end

  private

  def send
    {
      send: lambda do |request, response|
        WitResponder.new(request, response).send_response
      end
    }
  end

  def wit_methods
    method_names.map { |method| generate_hash(method) }.reduce(:merge)
  end

  def method_names
    I18n.t(:method_names, locale: :wit_actions)
  end

  def generate_hash(name)
    Hash[name.to_sym, generate_lambda(name)]
  end

  def generate_lambda(name)
    lambda do |request|
      generate_class(name).new(request: request).call
    end
  end

  def generate_class(name)
    "WitAction::#{name.camelize}Service".constantize
  end
end
