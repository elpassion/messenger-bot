class WitAction::ShowAboutUsService < WitAction
  def call
    context['about_us'] = first_entity_value 'about_us'
    context
  end
end
