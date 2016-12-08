$LOAD_PATH.unshift File.dirname(__FILE__)

require 'optparse'
require 'ostruct'
require 'crawler.rb'

ARGV << '-h' if ARGV.empty?
options = OpenStruct.new
OptionParser.new do |opt|
  opt.on('-u', '--url URL', 'The url to crawl') { |o| options.url = o }
  opt.on('-d', '--depth DEPTH', 'The depth of the links to reach') { |o| options.depth = o }
  opt.on_tail('-h', '--help', 'Show this message') do
    puts opt
    exit
  end
end.parse!

crawler = Crawler.new(options[:url], options[:depth])
result = crawler.crawl
jj result
