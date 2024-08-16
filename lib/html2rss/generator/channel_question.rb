# frozen_string_literal: true

require 'faraday'

require_relative 'question'

module Html2rss
  module Generator
    ##
    # Asks the required RSS channel options and tries to determine some.
    class ChannelQuestion < Question
      def self.validate(input:, state:, **_opts)
        uri = URI(input)
        return false unless uri.absolute?

        response = Faraday.new(url: uri, headers: {}).get

        if response.success?
          state.store(state.class::HTML_DOC_PATH, Helper.strip_down_html(response.body))
          return true
        end

        Helper.handle_unsuccessful_http_response(response.status, response.headers)
        false
      end

      private

      def before_ask
        PrintHelper.markdown <<~MARKDOWN
          # html2rss config generator

          This wizard will help you create a new *feed config*.

          You can quit at any time by pressing `Ctrl`+`C`.


        MARKDOWN
      end

      def process(url)
        { url:, language: doc.css('html').first['lang'], ttl: 360, time_zone: 'UTC' }
          .keep_if { |_key, value| value.to_s != '' }
      end

      def doc
        state.fetch(state.class::HTML_DOC_PATH)
      end
    end
  end
end
