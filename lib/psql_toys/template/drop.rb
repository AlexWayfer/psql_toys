# frozen_string_literal: true

module PSQLToys
	class Template
		## Define toys for database drop
		class Drop < Base
			on_expand do |template|
				tool :drop do
					include :exec, exit_on_nonzero_status: true, log_level: Logger::UNKNOWN

					desc 'Drop DB'

					flag :force, '-f', '--[no-]force'
					flag :confirmation, '--[no-]confirm', '--[no-]confirmation', default: true

					to_run do
						@database = template.db_config[:database]

						template.confirm "Drop #{@database} ? " if confirmation

						exec_tool 'db:dump' unless force

						template.db_connection.disconnect
						sh "dropdb --if-exists #{template.db_access} #{@database}"
					end
				end
			end
		end
	end
end
