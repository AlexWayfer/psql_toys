# frozen_string_literal: true

module PSQLToys
	class Template
		## Define toys for PSQL console
		class Console < Base
			on_expand do |template|
				tool :console do
					include :exec, exit_on_nonzero_status: true

					desc 'Start PSQL console'

					to_run do
						template.update_pgpass
						sh "psql #{template.db_access} #{template.db_config[:database]}"
					end
				end

				alias_tool :psql, :console
			end
		end
	end
end
