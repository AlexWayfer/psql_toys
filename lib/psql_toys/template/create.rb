# frozen_string_literal: true

module PSQLToys
	class Template
		## Define toys for database creation
		class Create < Base
			on_expand do |template|
				tool :create do
					desc 'Create empty DB'

					to_run do
						database = template.db_config[:database]

						sh "createdb -U postgres #{database} -O #{template.db_config[:user]}"

						exec_tool 'db:create_extensions'

						puts "Database #{database} created."
					end
				end
			end
		end
	end
end
