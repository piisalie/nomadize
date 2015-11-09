require 'test_helper'
require 'pg'

require 'nomadize/migrator'
require 'nomadize/migration'

class MigratorTest < Minitest::Test
  TEST_DB_NAME = 'nomadize_migrator_test'

  def test_creates_a_migration_table_automatically
    db = setup_database
    table_name = 'schema_migrations'

    assert_equal({"exists" => "f"}, check_for_table(table_name, db))
    migrator = Nomadize::Migrator.new(db: db, migrations: [ ])
    assert_equal({"exists" => "t"}, check_for_table(table_name, db))
  end

  def test_can_run_a_migration
    db = setup_database
    table_name = 'lol'
    migration = Nomadize::Migration.new(
      up: "CREATE TABLE #{table_name} (wat VARCHAR);",
      down: "",
      filename: 'lolwat')

    migrator = Nomadize::Migrator.new(db: db, migrations: [ migration ])

    assert_equal({"exists" => "f"}, check_for_table(table_name, db))
    migrator.run
    assert_equal({"exists" => "t"}, check_for_table(table_name, db))
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
      up: "ALTER TABLE testing ADD COLUMN nan INTEGER;",
      down: "",
      filename: '20151110lolwat')

    migrator = Nomadize::Migrator.new(db: db, migrations: [ migration2, migration1 ])
    assert migrator.run
  end

  def check_for_table(name, db)
    db.exec("SELECT EXISTS(SELECT * FROM information_schema.tables
             WHERE table_name = '#{name}');").to_a.first
  end

  def setup_database
    pg = PG.connect(dbname: 'postgres')
    if db_exists?(pg)
      db = PG.connect(dbname: TEST_DB_NAME)
      db.exec("SET client_min_messages TO WARNING;")
      db.exec("DROP SCHEMA public CASCADE;
               CREATE SCHEMA public;")
      db
    else
      pg.exec("CREATE DATABASE #{TEST_DB_NAME};")
      db = PG.connect(dbname: TEST_DB_NAME)
    end
  end

  def db_exists?(pg)
     result = pg.exec("SELECT EXISTS(
                             SELECT * FROM pg_database
                               WHERE datname='#{TEST_DB_NAME}');").to_a.first
     result.fetch("exists") == "t"
  end

end
