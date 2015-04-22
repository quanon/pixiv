require 'mechanize'
require 'ruby-progressbar'

module Pixiv
  class Client # Pixiv::Client
    TOP_URL = 'http://www.pixiv.net/index.php'.freeze
    LOGIN_URL = 'https://www.secure.pixiv.net/login.php'.freeze
    INTERVAL = 1

    def initialize(id = nil, password = nil)
      @id = id || ENV['PIXIV_ID']
      @password = password || ENV['PIXIV_PASSWORD']
    end

    def agent
      @agent ||= begin
        agent = Mechanize.new
        agent.max_history = 1
        agent.pluggable_parser['image/gif'] = Mechanize::Download
        agent.pluggable_parser['image/jpeg'] = Mechanize::Download
        agent.pluggable_parser['image/png'] = Mechanize::Download
        agent.user_agent_alias = 'Mac Safari'
        agent
      end
    end

    def login
      top_page = agent.get(TOP_URL)
      form = top_page.forms_with(action: LOGIN_URL).first
      form['pixiv_id'] = @id
      form['pass'] = @password
      home_page = form.submit
      home_page
    end

    def illust_ids(member_id)
      @illust_ids ||= {}
      @illust_ids[member_id] ||= begin
        (1..Float::INFINITY).inject([]) do |ids, i|
          page = Page::Works.new(self, member_id, i)
          break ids if page.empty?
          ids += page.illust_ids
          break ids if page.next.nil?
          ids.tap { sleep(INTERVAL) }
        end.sort
      end
    end

    def download(illust_id)
      medium_page = Page::Illust::Medium.new(self, illust_id)

      if medium_page.manga?
        medium_page.to_manga.big_pages.map do |manga_big_page|
          Downloader.downlaod(manga_big_page).tap { sleep(INTERVAL) }
        end
      else
        Downloader.downlaod(medium_page)
      end
    end

    def download_all(member_id)
      ids = illust_ids(member_id)
      progressbar = create_progressbar("[member_id: #{member_id}]", ids.length)

      success = []
      failure = []

      ids.each do |illust_id|
        begin
          download(illust_id)
          sleep(INTERVAL)
          success << illust_id
        rescue Downloader::NoDownloadUrlError => e
          failure << illust_id
        ensure
          progressbar.increment
        end
      end

      { success: success, failure: failure }
    end

    def create_progressbar(title, total)
      ProgressBar.create(
        title: title,
        total: total,
        format: '%t: %c/%C |%w>%i| %e '
      )
    end
  end
end
