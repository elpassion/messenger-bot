Hanami::Model.migration do
  change do
    rename_column :conversations, :candidate_info, :apply_job_shortcode
  end
end
