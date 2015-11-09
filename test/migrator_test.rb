require 'test_helper'
require 'pg'

require 'nomadize/migrator'
require 'nomadize/migration'

class MigratorTest < Minitest::Test

  def test_can_run_a_migration
    db = setup_database
    table_name = 'lol'
    migration = Nomadize::Migration.new(
      up: "CREATE TABLE #{table_name} (wat VARCHAR);",
      down: "",
      filename: 'lolwat')

    migrator = Nomadize::Migrator.new(db: db, migrations: [ migration ])

    refute check_for_table?(table_name, db)
    migrator.run
    assert check_for_table?(table_name, db)
  end

  def test_knows_which_migrations_are_pending
    db = setup_database
    migration = Nomadize::Migration.new(
      up: "CREATE TABLE IF NOT EXISTS testing (wat VARCHAR);",
      down: "",
      filename: 'lolwat')

    migrator = Nomadize::Migrator.new(db: db, migrations: [ migration ])

    assert_equal [ migration ], migrator.pending
    migrator.run
    assert_equal [ ], migrator.pending
  end

  def test_runs_migrations_in_order
    db = setup_database
    migration1 = Nomadize::Migration.new(
      up: "CREATE TABLE testing (wat VARCHAR);",
      down: "",
      filename: '20151109lolwat')
    migration2 = Nomadize::Migration.new(
      up: "ALTER TABLE testing ADD nan INTEGER;",
      down: "",
      filename: '20151110lolwat')

    migrator = Nomadize::Migrator.new(db: db, migrations: [ migration2, migration1 ])
    assert migrator.run
  end

  def test_can_rollback_a_migration
    db = setup_database
    migration1 = Nomadize::Migration.new(
      up: "CREATE TABLE testing (wat VARCHAR);",
      down: "DROP TABLE testing;",
      filename: '20151109lolwat')
    migration2 = Nomadize::Migration.new(
      up: "ALTER TABLE testing ADD nan INTEGER;",
      down: "ALTER TABLE testing DROP COLUMN nan;",
      filename: '20151110lolwat')
    Nomadize::Migrator.new(db: db, migrations: [ migration1, migration2 ]).run


    migrator = Nomadize::Migrator.new(db: db, migrations: [ migration1, migration2 ])
    assert check_for_table?('testing', db)
    migrator.rollback(2)
    refute check_for_table?('testing', db)
  end

end
