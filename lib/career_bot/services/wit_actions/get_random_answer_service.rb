class WitAction::GetRandomAnswerService < WitAction
  def call
    set_context_value 'answer', I18n.t('text_messages.unrecognized').sample
    context
  end
end
