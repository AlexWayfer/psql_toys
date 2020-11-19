# frozen_string_literal: true

require 'memery'

module PSQLToys
	class Template
		## Base class for templates
		class Base
			include Toys::Template
			include Memery

			## `db_config_proc` getter for `Dumps` sub-tools
			attr_reader :db_config_proc, :db_connection_proc, :db_extensions

			def initialize(db_config_proc:, db_extensions:, db_connection_proc: nil)
				@db_config_proc = db_config_proc
				@db_connection_proc = db_connection_proc
				@db_extensions = db_extensions
			end

			memoize def db_config
				db_config_proc.call
			end

			memoize def db_access(superuser: false)
				user = superuser ? db_config.fetch(:superuser, 'postgres') : db_config[:user]

				{ '-U' => user, '-h' => db_config[:host] }
					.compact
					.map { |key, value| "#{key} #{value}" }
					.join(' ')
			end

			memoize def db_connection
				db_connection_proc.call
			end

			PGPASS_FILE = File.expand_path '~/.pgpass'

			def update_pgpass
				pgpass_lines =
					File.exist?(PGPASS_FILE) ? File.read(PGPASS_FILE).split($RS) : []

				return if pgpass_lines&.include? pgpass_line

				File.write PGPASS_FILE, pgpass_lines.push(pgpass_line, nil).join($RS)
				File.chmod(0o600, PGPASS_FILE)
			end

			def confirm(prompt)
				require 'highline'
				highline = HighLine.new

				highline.choose do |menu|
					menu.layout = :one_line

					menu.prompt = prompt

					menu.choice(:yes) { nil }
					menu.choice(:no) { abort 'OK' }
				end
			end

			private

			memoize def pgpass_line
				db_config
					.fetch_values(:host, :port, :database, :user, :password) { |_key| '*' }
					.join(':')
			end

			# db_connection.loggers << Logger.new($stdout)
		end
	end
end
