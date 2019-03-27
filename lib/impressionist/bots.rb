require 'timeout'
require 'net/http'
require 'yaml'

module Impressionist
  module Bots
    LIST_URL = "https://raw.githubusercontent.com/podigee/device_detector/develop/regexes/bots.yml"
    def self.consume
      Timeout.timeout(4) do
        response = Net::HTTP.get(URI.parse(LIST_URL))
        list = YAML.safe_load(response)
        puts list.map { |entry| entry_details(entry) }
      end
    end

    def self.entry_details(entry)
      name = entry['name']
      regex = entry['regex']
      producer = entry['producer']

      result = "\nAgent: #{name}\nRegex: #{regex}\n"
      result += "Producer: #{producer['name']} - #{producer['url']}" if producer
      result
    end
  end
end
