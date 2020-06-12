# frozen_string_literal: true

module PSQLToys
	class Template
		## Define toys for PostgreSQL dumps
		class Dumps < Base
			on_expand do |template|
				tool :dumps do
					require_relative 'dumps/create'
					expand Dumps::Create, application: template.application

					require_relative 'dumps/restore'
					expand Dumps::Restore, application: template.application

					require_relative 'dumps/list'
					expand Dumps::List
				end

				alias_tool :dump, 'dumps:create'
				alias_tool :dumps, 'dumps:list'
				alias_tool :restore, 'dumps:restore'
			end
		end
	end
end
