require 'uri'
require 'active_support'
require 'active_support/core_ext'

module Pixiv
  module Page
    module Illust
      class Medium < Base # Pixiv::Page::Illust::Medium
        def initialize(client, illust_id)
          super(client, illust_id, :medium)
        end

        # @return [String]
        def download_url
          @download_url ||=
            mechanize_page.at('._illust_modal img.original-image').try(:attr, 'data-src')
        end

        # @return [Integer]
        def member_id
          @member_id ||= begin
            href = mechanize_page.at('.user-link').try(:attr, 'href')
            match_data = href.match(/id=(?<member_id>\d+)\z/)
            return nil if match_data.nil?
            match_data[:member_id].to_i
          end
        end

        # @return [String]
        def member_name
          @member_name ||=
            mechanize_page.at('.profile-unit .user').try(:text)
        end

        # @return [String]
        def title
          @title ||=
            mechanize_page.at('.work-info .title').try(:text)
        end

        def manga?
          mechanize_page.at('.multiple').present?
        end

        def to_manga
          manga_page
        end

        private

        def manga_page
          @manga_page ||= begin
            return nil if mechanize_page.at('.multiple').nil?

            Manga.new(@client, @illust_id, self)
          end
        end
      end
    end
  end
end
