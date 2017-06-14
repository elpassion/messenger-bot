Hanami::Model.migration do
  change do
    add_column :conversations, :notifications, 'boolean', default: false
  end
end
