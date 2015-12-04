# Nomadize

Nomadize is a collection of rake tasks for managing migrations using a PostgreSQL database. It does not import an entire ORM and aims to be a small / simple utility.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nomadize'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nomadize


## Usage

Nomadize supports two different methods for configuring the connection to Postgres. Nomadize will also provide access to the underlying PG connection wrapper (using your defined config) by using the `Nomadize::Config.db` method. This wrapper responds to `exec` in the same way that the underlying PG connection object does.

### Config File

You may use a config file `config/database.yml`. This file can be generated with either the rake task: `db:generate_template_config` or the CLI: `$ nomadize generate_template_config`. You can also choose to create the file for yourself. `config/database.yml` should look something like:

```
development:
  :dbname: lol_dev
test:
  :dbname: lol_test
production:
  :dbname: lol_production
```

The test/development/production keys define environment dependent options for the `PG.connection` based on the environment set via `RACK_ENV`. These key/value pairs are handed directly to the `PG.connect` method, documentation for what options can be passed can be found [here](http://deveiate.org/code/pg/PG/Connection.html#method-c-new).

The directory in which to find migrations files can optionally be set with the config:
`migrations_path: db/migrations`
The default value is `db/migrations`

### ENV['DATABASE_URL']

As of 0.4.0 Nomadize will also respect the `DATABASE_URL` environment variable. If `DATABASE_URL` is set it will override the connection information in the config file `config/database.yml`.
eg `postgres://user1:supersecure@somehost:1337/database-name` will result in the following configuration hash being passed to the underlying `PG.connection` object.

```ruby
{
  dbname:   'database-name',
  port:     1337,
  user:     'user1',
  password: 'supersecure',
  host:     'somehost'
}
```

### Migrations
After a config file is in place  add `require 'nomadize/tasks'` to your rake file, and enjoy helpful new rake tasks such as:

* `rake db:create` - creates a database and a schema_migrations table
* `rake db:drop`   - dumps your poor poor database
* `rake db:new_migration[migration_name]` - creates a timestamped migration file in db/migrations/ just fill in the details.
* `rake db:migrate` - runs migrations found in db/migrations that have not been run yet
* `rake db:status` - see which migrations have or have not been run
* `rake db:rollback[count]` - rollback migrations (default count: 1)
* `rake db:generate_template_config` - generate a config file in `config/database.yml`

Alternatively you can use the commandline tool `nomadize`:

* `nomadize create` - creates a database and a schema_migrations table
* `nomadize drop`   - dumps your poor poor database
* `nomadize new_migration $migration_name` - creates a timestamped migration file in db/migrations/ just fill in the details.
* `nomadize migrate` - runs migrations found in db/migrations that have not been run yet
* `nomadize status` - see which migrations have or have not been run
* `nomadize rollback $count` - rollback migrations (default count: 1)
* `nomadize generate_template_config` - generate a config file in `config/database.yml`

Migrations are written in SQL in the generated YAML files:

```
---
:up:   'CREATE TABLE testing (field TEXT);'
:down: 'DROP TABLE testing;'
```

## Development

todo:

- [x] an actual config setup / object
- [x] sql cleaning (getting rid of the interpolation)
- [x] to display migration status
- [x] migration rollbacks
- [ ] transactions / error handling
- [x] maybe some kind of logging idk
- [x] possibly wrap pg
- [x] template config file generator
- [x] maybe set a default migrations path (so the key isn't required in the config file)


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/piisalie/nomadize. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Changelog
0.4.0
  * support DATABASE_URL env variable
  * Add template_config generator to command line tool
  * Update the README
  * Added some basic logging
  * Fix an issue with rollback count not actually working :'(

0.3.0
  * Include a command line interface for Nomadize commands (THANKS [@moonglum](https://github.com/moonglum))

0.2.0
  * migration_path setting now has a default instead of being a required option in config/database.yml
  * Reworded some of the README.md
  * Added a rake task to generate a template config file in config/database.yml

0.1.0 - Initial Release
