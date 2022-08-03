# frozen_string_literal: true

require 'fileutils'
require_relative './files_and_paths'

module Html2rss
  module Generator
    ##
    # Asks if the user would like to persist the state 'feed' as a YAML file
    # and creating an rspec file using `RSPEC_TEMPLATE`.
    class FileCreateQuestion
      RSPEC_TEMPLATE = <<~RSPEC
        # frozen_string_literal: true

        RSpec.describe '%<rspec_yml_file_path>s' do
          include_examples 'config.yml', '%<rspec_yml_file_path>s'
        end
      RSPEC

      attr_reader :prompt, :feed_config, :channel_url

      def initialize(prompt, state, **_options)
        @prompt = prompt
        @state = state
        @feed_config = state.fetch(state.class::FEED_PATH)
        @channel_url = @feed_config.dig(:channel, :url)
      end

      def ask
        print_feed_config
        return unless prompt.yes?('Create YAML and spec files for this feed config?')

        config_name = ask_config_name

        fps = FilesAndPaths.new(
          Helper.replace_forbidden_characters_in_filename(config_name),
          Helper.url_to_directory_name(channel_url)
        )

        create(fps)
      end

      def self.print_files(relative_yml_path, relative_spec_path)
        PrintHelper.markdown <<~MARKDOWN
          Created YAML file at:
            `#{relative_yml_path}`

          Created spec file at:
            `#{relative_spec_path}`

          Use this config to generate RSS with:
            `bundle exec html2rss feed #{relative_yml_path}`
        MARKDOWN
      end

      def self.create_file(file_path, content)
        raise 'file exists already' if File.exist? file_path

        FileUtils.mkdir_p File.dirname(file_path)
        File.write(file_path, content)
      end

      private

      def print_feed_config
        PrintHelper.markdown <<~MARKDOWN
          **The feed config:**

          ```yaml
          #{Helper.to_simple_yaml(feed_config)}
          ```
        MARKDOWN
      end

      def ask_config_name
        directory_name = Helper.url_to_directory_name(channel_url)

        prompt.ask("Name this config for #{directory_name}:",
                   default: Helper.url_to_file_name(channel_url)) do |answer|
          answer.required true
          answer.validate(/^[^.][A-z0-9\-_]+[^.]$/)
          answer.modify :downcase
        end
      end

      def create(fps)
        write_to_yml(fps)
        scaffold_spec(fps)
        self.class.print_files(fps.relative_yml_path, fps.relative_spec_path)
      end

      def write_to_yml(fps)
        self.class.create_file fps.yml_file, Helper.to_simple_yaml(feed_config)
      end

      def scaffold_spec(fps)
        self.class.create_file fps.spec_file, format(RSPEC_TEMPLATE, { rspec_yml_file_path: fps.rspec_yml_file_path })
      end
    end
  end
end
