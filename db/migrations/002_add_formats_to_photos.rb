Sequel.migration do
  up do
    run "ALTER TABLE photos ADD COLUMN formats text[]"
  end

  down do
    run "ALTER TABLE photos DROP COLUMN formats"
  end
end
