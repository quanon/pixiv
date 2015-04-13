require 'uri'
require 'active_support'
require 'active_support/core_ext'

module Pixiv
  module Page
    module Illust
      class Base < Pixiv::Page::Base
        URL = 'http://www.pixiv.net/member_illust.php'.freeze

        attr_reader :illust_id, :page_number

        def initialize(client, illust_id, mode)
          @client = client
          @illust_id = illust_id
          @mode = mode
          @page_number = nil
        end

        private

        def query
          {
            mode: @mode,
            illust_id: @illust_id
          }
        end
      end
    end
  end
end
