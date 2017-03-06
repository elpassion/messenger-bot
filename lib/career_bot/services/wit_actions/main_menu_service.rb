class WitAction::MainMenuService < WitAction
  def call
    context['main_menu'] = first_entity_value 'main_menu'
    context
  end
end
