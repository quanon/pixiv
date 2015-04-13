require 'uri'
require 'active_support'
require 'active_support/core_ext'

module Pixiv
  module Page
    class Base
      attr_reader :client

      # @return [String]
      def url
        @url ||= begin
          uri = URI(self.class::URL)
          uri.query = query.to_param
          uri.to_s
        end
      end

      private

      # @return [Mechanize::Page]
      def mechanize_page
        @mechanize_page ||= @client.agent.get(url)
      end
    end
  end
end
