Hanami::Model.migration do
  change do
    create_table :conversations do
      primary_key :id
      column :session_id,   String
      column :context,      String
      column :created_at, DateTime
      column :updated_at, DateTime
    end
  end
end
