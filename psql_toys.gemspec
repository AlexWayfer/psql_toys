# frozen_string_literal: true

require_relative 'lib/psql_toys/version'

Gem::Specification.new do |spec|
	spec.name          = 'psql_toys'
	spec.version       = PSQLToys::VERSION
	spec.authors       = ['Alexander Popov']
	spec.email         = ['alex.wayfer@gmail.com']

	spec.summary       = 'Toys template for actions with PostgreSQL, like dumps.'
	spec.description   = <<~DESC
		Toys template for actions with PostgreSQL, like dumps.
	DESC
	spec.license = 'MIT'

	spec.required_ruby_version = '>= 2.7', '< 4'

	github_uri = "https://github.com/AlexWayfer/#{spec.name}"

	spec.homepage = github_uri

	spec.metadata = {
		'rubygems_mfa_required' => 'true',
		'bug_tracker_uri' => "#{github_uri}/issues",
		'changelog_uri' => "#{github_uri}/blob/v#{spec.version}/CHANGELOG.md",
		# 'documentation_uri' => "http://www.rubydoc.info/gems/#{spec.name}/#{spec.version}",
		'homepage_uri' => spec.homepage,
		'source_code_uri' => github_uri
		# 'wiki_uri' => "#{github_uri}/wiki"
	}

	spec.files = Dir['lib/**/*.rb', 'README.md', 'LICENSE.txt', 'CHANGELOG.md']

	spec.add_runtime_dependency 'alt_memery', '~> 2.0'
	spec.add_runtime_dependency 'gorilla_patch', '> 3', '< 6'
	spec.add_runtime_dependency 'toys-core', '~> 0.15.2'
end
