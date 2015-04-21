require 'uri'
require 'active_support'
require 'active_support/core_ext'

module Pixiv
  module Page
    class Works < Base
      URL = 'http://www.pixiv.net/member_illust.php'.freeze

      def initialize(client, member_id, page_number = 1)
        @client = client
        @member_id = member_id
        @page_number = page_number
      end

      def illust_ids
        image_links.map do |node|
          match_data = node['href'].match(/illust_id=(?<illust_id>\d+)/)
          next nil if match_data.nil?
          match_data[:illust_id].to_i
        end
      end

      # @return [Pixiv::Page::Works]
      def next
        next_works_page = Works.new(@client, @member_id, @page_number + 1)
        return nil if next_works_page.empty?
        next_works_page
      end

      # @return [Pixiv::Page::Works]
      def prev
        return nil if @page_number <= 1

        prev_works_page = Works.new(@client, @member_id, @page_number - 1)
        prev_works_page
      end

      def empty?
        image_links.empty?
      end

      private

      def query
        {
          id: @member_id,
          type: :all,
          p: @page_number
        }
      end

      # @return [Nokogiri::XML::Element]
      def image_links
        @image_links ||= mechanize_page.search('.image-item a')
      end
    end
  end
end
