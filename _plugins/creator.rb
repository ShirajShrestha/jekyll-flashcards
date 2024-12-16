require "dotenv/load"
require "trello"

module Jekyll
  class FlipCardDataGenerator < Generator
    safe true
    ACCEPTED_COLOR = "pink"

    def setup
      @trello_api_key = ENV['TRELLO_API_KEY']
      @trello_token = ENV['TRELLO_TOKEN']

      Trello.configure do |config|
        config.developer_public_key = @trello_api_key
        config.member_token = @trello_token
      end
    end

    def generate(site)
      setup

      cards = Trello::List.find("675fe08fc955fb8897db2a2d").cards

      flip_cards = cards.select do |card|
        card.labels.map(&:color).include?(ACCEPTED_COLOR)
      end.map do |card|
        {
          "keyword" => card.name,
          "definition" => card.desc
        }
      end

      site.data[ "flip_cards"] = flip_cards
    end
  end
end