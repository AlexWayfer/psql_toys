# frozen_string_literal: true

module PSQLToys
	class Template
		## Define toys for PostgreSQL dumps
		class Dumps < Base
			on_expand do |template|
				tool :dumps do
					require_relative 'dumps/_base'

					subtool_apply do
						include Dumps::Base::CommonPSQLDumpsCode
					end

					%w[Create List Restore].each do |template_name|
						require_relative "dumps/#{template_name.downcase}"
						expand Dumps.const_get(template_name, false),
							db_config_proc: template.db_config_proc,
							db_extensions: template.db_extensions
					end
				end

				alias_tool :dump, 'dumps:create'
				alias_tool :dumps, 'dumps:list'
				alias_tool :restore, 'dumps:restore'
			end
		end
	end
end
