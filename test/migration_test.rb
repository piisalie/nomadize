require 'test_helper'

require 'nomadize/migration'

class MigrationTest < Minitest::Test

  def setup
    @migration = Nomadize::Migration.new(
      up: "CREATE TABLE example (name TEXT);",
      down: "",
      filename: "20151108201341_create_example_table")
  end

  def test_it_inserts_a_filename_row_in_migrations_table
    db = setup_database

    refute migration_exists?(db, @migration.filename)
    @migration.run(db)
    assert migration_exists?(db, @migration.filename)
  end

  def test_it_removes_filename_row_when_rollingback
    db = setup_database
    @migration.run(db)

    assert migration_exists?(db, @migration.filename)
    @migration.rollback(db)
    refute migration_exists?(db, @migration.filename)
  end

  def migration_exists?(db, name)
    result = db.exec("SELECT EXISTS(
                        SELECT filename FROM schema_migrations
                          WHERE filename = $1);", [ name ]).
      to_a.first
    result.fetch("exists") == "t"
  end
end
