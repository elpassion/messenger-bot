Hanami::Model.migration do
  change do
    add_column :conversations, :question_index, Integer, default: 0
  end
end
