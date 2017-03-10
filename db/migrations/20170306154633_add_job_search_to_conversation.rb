Hanami::Model.migration do
  change do
    add_column :conversations, :job_codes, String
  end
end
