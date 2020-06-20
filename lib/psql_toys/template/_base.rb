# frozen_string_literal: true

module PSQLToys
	class Template
		## Base class for templates
		class Base
			include Toys::Template

			attr_reader :db_config_proc, :db_connection_proc, :db_extensions

			def initialize(db_config_proc:, db_connection_proc: nil, db_extensions:)
				@db_config_proc = db_config_proc
				@db_connection_proc = db_connection_proc
				@db_extensions = db_extensions
			end

			def db_config
				return @db_config if defined?(@db_config)

				@db_config = db_config_proc.call
			end

			def db_access
				@db_access ||=
					{ '-U' => db_config[:user], '-h' => db_config[:host] }
						.compact.map { |key, value| "#{key} #{value}" }.join(' ')
			end

			def db_connection
				return @db_connection if defined?(@db_connection)

				@db_connection = db_connection_proc.call
			end

			PGPASS_FILE = File.expand_path '~/.pgpass'

			def update_pgpass
				pgpass_lines =
					File.exist?(PGPASS_FILE) ? File.read(PGPASS_FILE).split($RS) : []

				return if pgpass_lines&.include? pgpass_line

				File.write PGPASS_FILE, pgpass_lines.push(pgpass_line, nil).join($RS)
				File.chmod(0o600, PGPASS_FILE)
			end

			private

			def pgpass_line
				@pgpass_line ||=
					db_config
						.fetch_values(:host, :port, :database, :user, :password) { |_key| '*' }
						.join(':')
			end

			# db_connection.loggers << Logger.new($stdout)
		end
	end
end
