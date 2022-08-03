# frozen_string_literal: true

require 'html2rss/generator/channel_question'

RSpec.describe Html2rss::Generator::ChannelQuestion do
  it { expect(described_class).to be < Html2rss::Generator::Question }
end
