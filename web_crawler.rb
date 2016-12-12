#!/usr/bin/env ruby
$LOAD_PATH.unshift File.dirname(__FILE__)

require 'optparse'
require 'ostruct'
require 'crawler.rb'

ARGV << '-h' if ARGV.empty?
options = OpenStruct.new(url: 'https://gocardless.com', depth: '0')
OptionParser.new do |opt|
  opt.on('-u', '--url URL', 'The url to crawl') { |o| options.url = o }
  opt.on('-d', '--depth DEPTH', 'The depth of the links to reach') { |o| options.depth = o }
  opt.on_tail('-h', '--help', 'Show this message') do
    puts opt
    exit
  end
end.parse!

crawler = Crawler.new(options[:url])
result = crawler.crawl(options[:depth].to_i)
jj result
