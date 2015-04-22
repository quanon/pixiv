require 'uri'
require 'active_support'
require 'active_support/core_ext'

module Pixiv
  module Page
    module Illust
      class MangaBig < Base
        delegate :member_id, :member_name, :title, to: :@medium_page

        def initialize(client, illust_id, page_number = 1, medium_page)
          super(client, illust_id, :manga_big)
          @page_number = page_number
          @medium_page = medium_page
        end

        def download_url
          @download_url ||= mechanize_page.at('img').try(:attr, 'src')
        end

        def manga?
          true
        end

        private

        def query
          {
            mode: @mode,
            illust_id: @illust_id,
            page: @page_number
          }
        end
      end
    end
  end
end
