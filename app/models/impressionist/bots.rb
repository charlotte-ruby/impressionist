module Impressionist
  module Bots

    def self.bot?(user_agent = nil)
      return false if user_agent.nil?
      WILD_CARDS.any? { |wc| user_agent.downcase.include?(wc) } || LIST.include?(user_agent)
    end

    WILD_CARDS = ["bot","yahoo","slurp","google","msn","crawler"]

    file = File.open(File.join(File.dirname(__FILE__), '../../../lib/botlist/') + 'crawler-user-agents.json')
    my_hash = JSON.parse(file.read)
    list = []
    my_hash.each do |agent|
      list << agent['instances']
    end
    LIST = list.flatten
  end
end
