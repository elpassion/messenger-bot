class WitAction::GetSocialNetworkService < WitAction

  def call
    if check_social_network
      context['found'] = true
      context['address'] = check_social_network
    else
      context['notFound'] = true
    end
    context
  end

  private

  def check_social_network
    I18n.t(social_network, locale: :social_networks) if I18n.exists?(social_network, :social_networks)
  end

  def social_network
    context['social_network'] = first_entity_value 'social_network'
  end
end
