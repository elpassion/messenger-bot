Hanami::Model.migration do
  change do
    add_column :conversations, :messenger_id, String, null: false, unique: true
    rename_column :conversations, :session_id, :session_uid
  end
end
