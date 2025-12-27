# frozen_string_literal: true

require 'timeout'
require 'net/http'
require 'nokogiri'
require 'set'

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
          list << agent.xpath("String").text.gsub("&lt;", "<") if ["R", "S"].include?(type)
        end
        list
      end
    end

    def self.bot?(user_agent = nil)
      return false if user_agent.nil?

      ua_downcase = user_agent.downcase

      # Real browsers are not bots - check this first
      return false if real_browser?(ua_downcase)

      # Check wildcards and static list
      WILD_CARDS.any? { |wc| ua_downcase.include?(wc) } || LIST.include?(user_agent)
    end

    def self.real_browser?(ua)
      # Common browser signatures that indicate a real user
      # These patterns appear in legitimate browsers, not bots
      return false if ua.nil?

      # Must have Mozilla/5.0 AND one of the browser engines
      return false unless ua.include?('mozilla/5.0')

      # Check for real browser engines (bots don't typically have these combinations)
      browser_engines = [
        'applewebkit/',  # Chrome, Safari, Edge
        'gecko/',        # Firefox
        'presto/',       # Old Opera
        'trident/'       # IE
      ]

      has_engine = browser_engines.any? { |engine| ua.include?(engine) }

      # Additional check: real browsers have specific browser identifiers
      browser_identifiers = [
        'chrome/',
        'safari/',
        'firefox/',
        'edg/',          # Edge
        'opr/',          # Opera
        'msie ',         # IE
        'rv:11'          # IE 11
      ]

      has_browser = browser_identifiers.any? { |browser| ua.include?(browser) }

      has_engine && has_browser
    end

    # Wildcards to detect bots - removed 'google' as it matches Chrome
    WILD_CARDS = %w[
      bot
      crawler
      spider
      slurp
      scraper
      fetch
      nutch
      wget
      curl
      archiver
      transcoder
      yahoo
      msn
    ].freeze

    # Static list of known bots (abbreviated - full list from original)
    LIST = Set.new([
      "Googlebot/2.1 (+http://www.google.com/bot.html)",
      "Googlebot-Image/1.0",
      "Mediapartners-Google",
      "AdsBot-Google",
      "Bingbot/2.0",
      "msnbot/2.0b",
      "Slurp",
      "DuckDuckBot/1.0",
      "Baiduspider",
      "YandexBot/3.0",
      "Sogou web spider",
      "Exabot/3.0",
      "facebot",
      "facebookexternalhit/1.1",
      "Twitterbot",
      "LinkedInBot/1.0",
      "Pinterest",
      "Applebot/0.1",
      "ia_archiver",
      "archive.org_bot",
      "Screaming Frog SEO Spider",
      "AhrefsBot/5.0",
      "SemrushBot",
      "DotBot",
      "MJ12bot",
      "Uptimebot",
      "PetalBot",
      "AspiegelBot"
    ]).freeze
  end
end