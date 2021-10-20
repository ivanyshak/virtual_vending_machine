# frozen_string_literal: true

require_relative 'app/services/loader'

CONFIG = 'app/database/config.yml'

config   = YAML.load_file(ARGV.first || CONFIG)
database = Database.new(config)

service  = Executor.new(database)

Presenter.new(service).call
