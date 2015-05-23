require 'rubygems'
require 'open-uri'
require 'nokogiri'
require 'mini_magick'
require 'rufus-scheduler'
require_relative './app'

config_path = File.expand_path("../config.yml", __FILE__)
debug_path = File.expand_path("../debug.log", __FILE__)
lock_path = File.expand_path("../.rufus-scheduler.lock", __FILE__)

ActiveRecord::Base.logger = Logger.new(debug_path)
configuration = YAML::load(IO.read(config_path))
ActiveRecord::Base.establish_connection(configuration['development'])

scheduler = Rufus::Scheduler.new(:lockfile => lock_path)

$header = configuration['weibo']

# scheduler.every("10s") do
#   BoringImage.fetch
# end

# scheduler.join