require 'nomadize/version'
require 'nomadize/migration_loader'
require 'nomadize/migration'
require 'nomadize/migrator'
require 'nomadize/config'
require 'nomadize/status_display'
require 'nomadize/file_generator'

module Nomadize

  def self.run_migrations
    db              = Config.db
    migration_files = MigrationLoader.new(path: Config.migrations_path).migrations
    migrations      = migration_files.map { |migration| Migration.new(migration) }
    migrator        = Migrator.new(db: db, migrations: migrations)

    files_migrated = migrator.run
    puts files_migrated
    db
  end

  def self.create_database
    system("createdb --echo #{Config.database_name}")
    db = Config.db
    db.create_schema_migrations_table
    db
  end

  def self.status
    files   = MigrationLoader.new(path: Config.migrations_path).migrations
    db      = Config.db
    records = db.retrieve_all_migration_filenames

    display = StatusDisplay.new(files: files, records: records)

    puts display.titlebar
    puts display.divider
    display.migrations.each do |row|
      puts row
    end
  end

  def self.rollback(count = 1)
    db              = Config.db
    migration_files = MigrationLoader.new(path: Config.migrations_path).migrations
    migrations      = migration_files.map { |migration| Migration.new(migration) }
    migrator        = Migrator.new(db: db, migrations: migrations)

    files_rolled_back = migrator.rollback(count)
    puts files_rolled_back
    db
  end

  def self.drop_database
    system("dropdb --echo #{Config.database_name}")
  end

  def self.generate_template_migration_file(name)
    migration_file = Nomadize::FileGenerator.new(path: Config.migrations_path, name: name).save
    puts "Migration file created: #{Dir.pwd}/#{migration_file}"
  end

  def self.generate_template_config
    fail 'Config file already exists' if File.exists?('config/database.yml')
    template_config = YAML.dump(
      { 'development' => { dbname: '' },
        'test'        => { dbname: '' },
        'production'  => { dbname: '' }
      } )
    FileUtils.mkdir 'config' unless File.exists?('config')
    File.open('config/database.yml', 'w') { |f| f.write(template_config) }
  end

end
