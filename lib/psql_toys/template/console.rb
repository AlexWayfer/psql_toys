# frozen_string_literal: true

module PSQLToys
	class Template
		## Define toys for PSQL console
		class Console < Base
			on_expand do
				tool :console do
					desc 'Start PSQL console'

					def run
						update_pgpass
						sh "psql #{db_access} #{db_config[:database]}"
					end
				end

				alias_tool :psql, :console
			end
		end
	end
end
