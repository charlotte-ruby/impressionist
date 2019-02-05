require 'timeout'
require 'net/http'
require 'json'

module Impressionist
  module Bots
    LIST_URL = "https://raw.githubusercontent.com/monperrus/crawler-user-agents/master/crawler-user-agents.json"
    def self.consume
      Timeout.timeout(4) do
        response = Net::HTTP.get(URI.parse(LIST_URL))
        my_hash = JSON.parse(response)
        list = []
        my_hash.each do |agent|
          list << agent['instances']
        end
        pp list.flatten
      end
    end
  end
end
