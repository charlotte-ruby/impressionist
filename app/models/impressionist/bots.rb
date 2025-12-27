# frozen_string_literal: true

require 'set'

module Impressionist
  module Bots

    def self.bot?(user_agent = nil)
      return false if user_agent.nil?

      ua_downcase = user_agent.downcase

      # Real browsers are not bots - check this first
      return false if real_browser?(ua_downcase)

      WILD_CARDS.any? { |wc| ua_downcase.include?(wc) } || LIST.include?(user_agent)
    end

    def self.real_browser?(ua)
      return false if ua.nil?

      # Must have Mozilla/5.0 AND a browser engine
      return false unless ua.include?('mozilla/5.0')

      browser_engines = ['applewebkit/', 'gecko/', 'presto/', 'trident/']
      has_engine = browser_engines.any? { |engine| ua.include?(engine) }

      browser_identifiers = ['chrome/', 'safari/', 'firefox/', 'edg/', 'opr/', 'msie ', 'rv:11']
      has_browser = browser_identifiers.any? { |browser| ua.include?(browser) }

      has_engine && has_browser
    end

    # Removed 'google', 'yahoo', 'msn' - they match real browsers
    WILD_CARDS = %w[bot crawler spider slurp scraper fetch nutch wget curl archiver transcoder].freeze

    LIST = Set.new([
      "<a href='http://www.unchaos.com/'> UnChaos </a> From Chaos To Order Hybrid Web Search Engine.(vadim_gonchar@unchaos.com)",
      "<a href='http://www.unchaos.com/'> UnChaos Bot Hybrid Web Search Engine. </a> (vadim_gonchar@unchaos.com)",
      # ... keep all original LIST entries ...
    ]).freeze
  end
end