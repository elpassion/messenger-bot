Hanami::Model.migration do
  change do
    set_column_type :conversations, :apply_job_shortcode, String
  end
end
