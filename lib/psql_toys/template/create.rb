# frozen_string_literal: true

module PSQLToys
	class Template
		## Define toys for database creation
		class Create < Base
			on_expand do |template|
				tool :create do
					include :exec, exit_on_nonzero_status: true

					desc 'Create empty DB'

					to_run do
						database = template.db_config[:database]

						sh "createdb -U postgres #{database} -O #{template.db_config[:user]}"
						template.db_extensions.each do |db_extension|
							sh "psql -U postgres -c 'CREATE EXTENSION #{db_extension}' #{database}"
						end

						puts "Database #{database} created."
					end
				end
			end
		end
	end
end
