# frozen_string_literal: true

require 'html2rss'
require 'tty-prompt'

require_relative 'generator/helper'
require_relative 'generator/print_helper'
require_relative 'generator/collector'
require_relative 'generator/file_create_question'
require_relative 'generator/state'

module Html2rss
  ##
  # Namespace for the Feed Config Generator.
  module Generator
    ##
    # Asks the caller questions, using prompt and stores the results in the state.
    # @return [nil]
    def self.start(prompt = TTY::Prompt.new, state = State.new(feed: {}))
      Collector.new(prompt, state).collect

      FileCreateQuestion.new(prompt, state).ask
    end
  end
end
