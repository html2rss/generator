# frozen_string_literal: true

require 'html2rss/generator/items_selector_question'

RSpec.describe Html2rss::Generator::ItemsSelectorQuestion do
  it { expect(described_class).to be < Html2rss::Generator::SelectorQuestion }
end
