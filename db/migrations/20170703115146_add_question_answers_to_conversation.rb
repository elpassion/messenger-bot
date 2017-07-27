Hanami::Model.migration do
  change do
    add_column :conversations, :text_answers, 'jsonb'
    add_column :conversations, :complex_answers, 'jsonb'
  end
end
