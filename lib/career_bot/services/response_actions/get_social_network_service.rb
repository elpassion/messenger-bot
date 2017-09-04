class ResponseAction::GetSocialNetworkService < ResponseAction
  private

  def data
    if social_network_address
      { social_network: social_network, address: social_network_address }
    else
      { social_network: social_network }
    end
  end

  def value
    social_network_address ? 'found' : 'not_found'
  end

  def social_network_address
    return unless social_network_exists?
    @social_network_address ||= I18n.t(social_network, locale: :social_networks)
  end

  def social_network_exists?
    I18n.exists?(social_network, :social_networks)
  end

  def social_network
    @social_network ||= entities[entities.keys.first].first['value']
  end
end
