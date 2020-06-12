# frozen_string_literal: true

module PSQLToys
	class Template
		## Define toys for database creation
		class Create < Base
			on_expand do
				tool :create do
					desc 'Create empty DB'

					def run
						## https://github.com/rubocop-hq/rubocop/issues/7884
						# rubocop:disable Layout/IndentationStyle
						sh "createdb -U postgres #{db_config[:database]}" \
						   " -O #{db_config[:user]}"
						DB_EXTENSIONS.each do |db_extension|
							sh "psql -U postgres -c 'CREATE EXTENSION #{db_extension}'" \
							   " #{db_config[:database]}"
						end
						# rubocop:enable Layout/IndentationStyle
					end
				end
			end
		end
	end
end
