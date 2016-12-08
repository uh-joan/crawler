require 'nokogiri'
require 'open-uri'
require 'json'

class Crawler
  def initialize(url, depth = 1)
    @url = url
    @depth = depth.to_i
    @doc = Nokogiri::HTML(open(@url, "Accept-Encoding" => "plain", "User-Agent" => "chrome"))

    @output = []
    unless @doc.nil?
      assets = extract_assets @doc
      @output << { url: @url, assets: assets.to_json }
    end

  end

  def crawl
    depth_count = 0

    # loop over depth to reach
    unless @doc.nil?
      while depth_count <= @depth
        links = extract_links @doc

        links.each do |link|
          if is_a_partial_link_and_of_depth(link, depth_count)
            new_url = @url + link
            doc = Nokogiri::HTML(open(new_url, "Accept-Encoding" => "plain", "User-Agent" => "chrome"))
            assets = extract_assets doc
            @output  << { url: new_url, assets: assets.to_json }
          end
        end

        depth_count+=1
      end
    end

    @output
  end

  def is_a_partial_link_and_of_depth (link, depth)
    begin
      # account only for partial links
      route_elements = link.split('/')
      (route_elements[0].empty? && route_elements.count == depth+1) ? true : false
    rescue
      false
    end
  end

  def extract_links (doc)
    # lets consider only the link within a tag
    links = doc.css('a').map { |link| link['href'] }
    links.compact.uniq
  end

  def extract_assets (doc)
    # lets consider assets in link, script and image elements
    assets = []
    assets << doc.xpath('//link[not(@rel="alternate")][not(@rel="canonical")][not(@rel="publisher")]').map{ |link| link['href'] }
    assets << doc.xpath('//script').map{ |link| link['src'] }
    assets << doc.xpath('//image').map { |link| link['src'] }
    # get rid of nils, duplicates and attach the domain to only the assets with partial links
    assets.flatten.compact.uniq.map { |asset| asset.start_with?('/') && !asset.start_with?('//')? @url+asset : asset }
  end
end