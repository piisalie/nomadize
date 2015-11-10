# Nomadize

Some simple tools for managing migrations with postgres (without requiring an entire ORM).

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

Nomadize expects a database configuration file in `config/database.yml`. This file should look something like:

```
migrations_path: db/migrations
development:
  :dbname: lol_dev
test:
  :dbname: lol_test
production:
  :dbname: lol_production
```

`migrations_path` defines where Nomadize should find and create your migration files.

The test/development/production keys set environment dependent options (through `RACK_ENV`) for the postgres connection object. These key/value pairs are handed directly to the `PG.connect` method, documentation for what options can be passed can be found [here](http://deveiate.org/code/pg/PG/Connection.html#method-c-new).

After a config file is in place  add `require 'nomadize/tasks'` to your rake file, and enjoy helpful new rake tasks such as:

* `rake db:create` - creates a database and a schema_migrations table
* `rake db:drop`   - dumps your poor poor database
* `rake db:new_migration[migration_name]` - creates a timestamped migration file in db/migrations/ just fill in the details.
* `rake db:migrate` - runs migrations found in db/migrations that have not been run yet
* `rake db:status` - see which migrations have or have not been run
* `rake db:rollback[count]` - rollback migrations (default count: 1)


## Development

todo:

- [x] an actual config setup / object
- [x] sql cleaning (getting rid of the interpolation)
- [x] to display migration status
- [x] migration rollbacks
- [ ] transactions / error handling
- [ ] maybe some kind of logging idk
- [x] possibly wrap pg


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/piisalie/nomadize. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
