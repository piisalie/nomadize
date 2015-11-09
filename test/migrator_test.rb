require 'test_helper'

require 'nomadize/migrator'

class MigratorTest < Minitest::Test
  TEST_DB_NAME = 'nomadize_migrator_test'

  def test_creates_a_migration_table
    build_fresh_db
    db = PG.connect(dbname: TEST_DB_NAME)
    migrator = Nomadize::Migrator.new(db: db, migrations: [ ])

    assert_equal({"exists" => "f"}, check_for_migration_table(db))
    migrator.run
    assert_equal({"exists" => "t"}, check_for_migration_table(db))
  end

  def build_fresh_db
    @pg = PG.connect(dbname: 'postgres')
    @pg.exec("DROP DATABASE #{TEST_DB_NAME};")
    @pg.exec("CREATE DATABASE #{TEST_DB_NAME};")
  end

  def check_for_migration_table(db)
    db.exec("SELECT EXISTS(SELECT * FROM information_schema.tables
             WHERE table_name = 'schema_migrations');").to_a.first
  end


# it runs migrations
# it only runs migrations that haven't been run
end
