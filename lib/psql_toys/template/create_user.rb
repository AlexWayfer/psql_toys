# frozen_string_literal: true

module PSQLToys
	class Template
		## Define toys for database user creation
		class CreateUser < Base
			on_expand do |template|
				tool :create_user do
					include :exec, exit_on_nonzero_status: true, log_level: Logger::UNKNOWN

					desc 'Create an user for DB'

					to_run do
						user = template.db_config[:user]
						password = template.db_config[:password]
						password_option = "-P #{password}" if password

						sh <<~CMD
							createuser #{template.db_access(superuser: true)} #{user} #{password_option}
						CMD

						puts "User #{user} created."
					end
				end
			end
		end
	end
end
