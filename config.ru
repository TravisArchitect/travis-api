$: << 'lib'

# Make sure we set that before everything
ENV['RACK_ENV'] ||= ENV['RAILS_ENV'] || ENV['ENV']
ENV['RAILS_ENV']  = ENV['RACK_ENV']

$stdout.sync = true

require 'travis/api/app'
require 'core_ext/module/load_constants'

models = Travis::Model.constants.map(&:to_s)
only   = [/^(ActiveRecord|ActiveModel|Travis|#{models.join('|')})/]
skip   = ['Travis::Memory', 'Travis::Helpers::Legacy']

[Travis::Api, Travis].each do |target|
  target.load_constants! :only => only, :skip => skip, :debug => false
end

run Travis::Api::App.new
