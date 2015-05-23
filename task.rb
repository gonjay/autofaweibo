require 'rubygems'
require 'open-uri'
require 'nokogiri'
require 'mini_magick'
require 'rufus-scheduler'
require_relative './app'

lock_path = File.expand_path("../.rufus-scheduler.lock", __FILE__)
scheduler = Rufus::Scheduler.new(:lockfile => lock_path)

$header = $configuration['weibo']

# scheduler.every("10s") do
#   BoringImage.fetch
# end

# scheduler.join

# BoringImage.fetch