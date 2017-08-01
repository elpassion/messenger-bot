Hanami::Model.migration do
  change do
    add_column :conversations, :apply, 'boolean'
    add_column :conversations, :candidate_info, 'jsonb'
  end
end
