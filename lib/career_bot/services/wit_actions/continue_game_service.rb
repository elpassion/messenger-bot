class WitAction::ContinueGameService < WitAction
  def call
    remove_from_context 'wrongParam'
    context
  end
end
