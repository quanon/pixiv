require 'uri'
require 'active_support'
require 'active_support/core_ext'

module Pixiv
  module Page
    module Illust
      class Manga < Base
        def initialize(client, illust_id, medium_page)
          super(client, illust_id, :manga)
          @medium_page = medium_page
        end

        def download_url
          nil
        end

        def manga?
          true
        end

        def big_pages
          @big_pages ||= begin
            mechanize_page.search('a.full-size-container').map do |node|
              query_string = URI.parse(node['href']).query
              query = URI::decode_www_form(query_string).to_h
              MangaBig.new(@client, @illust_id, query['page'], @medium_page)
            end
          end
        end
      end
    end
  end
end
