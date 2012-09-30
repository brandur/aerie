Sequel.migration do
  change do
    create_table :photos do
      primary_key :id
      String :key, null: false
      Text :description
      Text :filename, null: false
      DateTime :created_at, null: false
      DateTime :updated_at
    end
  end
end
