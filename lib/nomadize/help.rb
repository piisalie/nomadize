module Nomadize
  @help = {
    create: 'Create database using name in {appdir}/config/database.yml',
    drop: 'Drop database using name in {appdir}/config/database.yml',
    new_migration: 'Generate a migration template file. default directory: {appdir}/db/migrations',
    migrate: 'Run migrations',
    status: 'View the status of known migrations',
    rollback: 'Rollback migrations (default count: 1)'
  }
  class << self; attr_reader :help; end
end
