# PSQL Toys

[![Gem](https://img.shields.io/gem/v/psql_toys.svg?style=flat-square)](https://rubygems.org/gems/psql_toys)
[![Cirrus CI - Base Branch Build Status](https://img.shields.io/cirrus/github/AlexWayfer/psql_toys?style=flat-square)](https://cirrus-ci.com/github/AlexWayfer/psql_toys)
[![Codecov branch](https://img.shields.io/codecov/c/github/AlexWayfer/psql_toys/main.svg?style=flat-square)](https://codecov.io/gh/AlexWayfer/psql_toys)
[![Code Climate](https://img.shields.io/codeclimate/maintainability/AlexWayfer/psql_toys.svg?style=flat-square)](https://codeclimate.com/github/AlexWayfer/psql_toys)
[![Depfu](https://img.shields.io/depfu/AlexWayfer/psql_toys?style=flat-square)](https://depfu.com/repos/github/AlexWayfer/psql_toys)
[![Inline docs](https://inch-ci.org/github/AlexWayfer/psql_toys.svg?branch=main)](https://inch-ci.org/github/AlexWayfer/psql_toys)
[![license](https://img.shields.io/github/license/AlexWayfer/psql_toys.svg?style=flat-square)](https://github.com/AlexWayfer/psql_toys/blob/main/LICENSE.txt)
[![License](https://img.shields.io/github/license/AlexWayfer/psql_toys.svg?style=flat-square)](LICENSE.txt)

Toys template for actions with PostgreSQL, like dumps.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'psql_toys'
```

And then execute:

```shell
bundle install
```

Or install it yourself as:

```shell
gem install psql_toys
```

## Usage

```ruby
application_proc = proc do
  require "#{context_directory}/application"
  MyProject::Application
end

require 'psql_toys'
expand PSQLToys::Template,
  db_config_proc: proc { application_proc.call.config[:database] },
  db_connection_proc: proc { application_proc.call.db_connection },
  db_extensions: %w[citext pgcrypto] # this is default, can be changed

# `database` namespace created
# aliases are optional, but handful
alias_tool :db, :database
```

`db_config` must have `:database` key, and my have `:host`, `:port`, `:user`,
`:superuser` (for database and user creation) and `:password` keys.

## Development

After checking out the repo, run `bundle install` to install dependencies.

Then, run `toys rspec` to run the tests.

To install this gem onto your local machine, run `toys gem install`.

To release a new version, run `toys gem release %version%`.
See how it works [here](https://github.com/AlexWayfer/gem_toys#release).

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/AlexWayfer/psql_toys).

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).
