# frozen_string_literal: true

module PSQLToys
	class Template
		## Define toys for database extensions creation
		class CreateExtensions < Base
			on_expand do |template|
				tool :create_extensions do
					include :exec, exit_on_nonzero_status: true

					desc 'Create extensions for existing DB'

					to_run do
						db_access = template.db_access(superuser: true)
						database = template.db_config[:database]

						template.db_extensions.each do |db_extension|
							sh "psql #{db_access} -c 'CREATE EXTENSION #{db_extension}' #{database}"
						end
					end
				end
			end
		end
	end
end
