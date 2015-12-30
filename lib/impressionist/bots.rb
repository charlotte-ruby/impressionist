require 'timeout'
require 'net/http'
require 'nokogiri'

module Impressionist
  module Bots
    LIST_URL = "http://www.user-agents.org/allagents.xml"
    def self.consume
      Timeout.timeout(4) do
        response = Net::HTTP.get(URI.parse(LIST_URL))
        doc = Nokogiri::XML(response)
        list = []
        doc.xpath('//user-agent').each do |agent|
          type = agent.xpath("Type").text
          list << agent.xpath("String").text.gsub("&lt;","<") if ["R","S"].include?(type) #gsub hack for badly formatted data
        end
        list
      end
    end
  end
end
