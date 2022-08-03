# frozen_string_literal: true

require 'html2rss/generator/selector_question'

RSpec.describe Html2rss::Generator::SelectorQuestion do
  it { expect(described_class).to be < Html2rss::Generator::Question }
end
