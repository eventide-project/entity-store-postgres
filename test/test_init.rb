ENV['CONSOLE_DEVICE'] ||= 'stdout'
ENV['LOG_LEVEL'] ||= '_min'

puts RUBY_DESCRIPTION

require_relative '../init.rb'

require 'test_bench'; TestBench.activate

require 'securerandom'

require 'entity_store/postgres/controls'
Controls = ::EntityStore::Postgres::Controls
