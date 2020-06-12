# frozen_string_literal: true

require 'toys-core'

module PSQLToys
	## Define toys for Sequel migrations
	class Template
		include Toys::Template

		attr_reader :application

		def initialize(application:)
			@application = application
		end

		on_expand do |template|
			require_relative 'template/_base'

			require_relative 'template/create'
			expand Template::Create, application: template.application

			require_relative 'template/drop'
			expand Template::Drop, application: template.application

			require_relative 'template/console'
			expand Template::Console, application: template.application

			require_relative 'template/dumps'
			expand Template::Dumps, application: template.application
		end
	end
end
