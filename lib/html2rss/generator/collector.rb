# frozen_string_literal: true

require_relative 'channel_question'
require_relative 'items_selector_question'
require_relative 'selector_question'

module Html2rss
  module Generator
    ##
    # Contains the questions to ask on `prompt`.
    class Collector
      def initialize(prompt, state)
        @state = state
        @prompt = prompt
      end

      # rubocop:disable Metrics/MethodLength
      def collect
        [
          ChannelQuestion.new(prompt, state, path: 'feed.channel',
                                             question: 'Please enter the URL to scrape:'),
          ItemsSelectorQuestion.new(prompt, state, path: 'feed.selectors.items',
                                                   question: 'Items selector:',
                                                   prompt_options: { default: 'article' }),
          SelectorQuestion.new(prompt, state, path: 'feed.selectors.title',
                                              question: 'Title selector:',
                                              prompt_options: { default: '[itemprop=headline]' }),
          SelectorQuestion.new(prompt, state, path: 'feed.selectors.link',
                                              question: 'URL selector:',
                                              prompt_options: { default: 'a:first' }),
          SelectorQuestion.new(prompt, state, path: 'feed.selectors.description',
                                              question: 'Description selector:',
                                              prompt_options: { default: '[itemprop=description]' })
        ].each(&:ask)
      end
      # rubocop:enable Metrics/MethodLength

      private

      attr_reader :state, :prompt
    end
  end
end
