# frozen_string_literal: true

module Impressionist
  module Bots
    def self.bot?(user_agent = nil)
      return false if user_agent.nil? || user_agent.empty?

      normalized_agent = user_agent.to_s.downcase

      return true if WILD_CARDS.any? { |wc| normalized_agent.include?(wc) }

      LIST.include?(user_agent)
    end

    WILD_CARDS = %w[
      bot
      crawler
      spider
      slurp
      googlebot
      bingbot
      yandex
      baidu
      duckduckgo
      facebookexternalhit
      twitterbot
      linkedinbot
      pinterest
      whatsapp
      telegram
      discord
      slack
      semrush
      ahrefs
      moz
      screaming
      archive
      wget
      curl
      python
      java
      php
      perl
      ruby
      libwww
      httpclient
      okhttp
      axios
      node-fetch
      go-http-client
      apache-httpclient
    ].freeze

    LIST = Set.new([
      "Googlebot/2.1 (+http://www.google.com/bot.html)",
      "Googlebot-Image/1.0",
      "Googlebot-News",
      "Googlebot-Video/1.0",
      "Mediapartners-Google",
      "AdsBot-Google (+http://www.google.com/adsbot.html)",
      "Bingbot/2.0",
      "msnbot/2.0b (+http://search.msn.com/msnbot.htm)",
      "Yahoo! Slurp",
      "DuckDuckBot/1.0",
      "Baiduspider",
      "YandexBot/3.0",
      "facebookexternalhit/1.1",
      "Twitterbot/1.0",
      "LinkedInBot/1.0",
      "Pinterest/0.2",
      "WhatsApp/2.0",
      "TelegramBot",
      "Slackbot-LinkExpanding 1.0",
      "Discordbot/2.0",
      "ia_archiver",
      "archive.org_bot",
      "Screaming Frog SEO Spider",
      "AhrefsBot/7.0",
      "SemrushBot/7",
      "MJ12bot/v1.4.8",
      "DotBot/1.1",
      "Applebot/0.1",
      "PetalBot",
      "SeznamBot/3.2",
      "Sogou web spider",
      "Exabot/3.0",
      "Qwantify/2.4w",
      "CCBot/2.0"
    ]).freeze
  end
end