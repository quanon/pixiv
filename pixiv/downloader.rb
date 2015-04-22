module Pixiv
  class Downloader # Pixiv::Downloader
    DOWNLOAD_DIR = ENV['PIXIV_DOWNLOAD_DIR'] || '/tmp'

    class NoDownloadUrlError < StandardError; end

    def self.downlaod(page)
      new(page).downlaod
    end

    def initialize(page)
      @page = page
      @client = page.client
    end

    def downlaod
      fail(NoDownloadUrlError, "[#{@page.illust_id}] downlaod url is null") if download_url.nil?

      return nil if FileTest.exist?(filepath)
      FileUtils.mkdir_p(downlaod_dir)
      @client.agent.download(download_url, filepath, [], referer)
      filepath
    end

    private

    def download_url
      @page.download_url
    end

    def referer
      @page.url
    end

    def filepath
      @filepath ||= File.join(downlaod_dir, filename)
    end

    def downlaod_dir
      @downlaod_dir ||=
        if @page.manga?
          File.join(DOWNLOAD_DIR, member_dir, illust_dir)
        else
          File.join(DOWNLOAD_DIR, member_dir)
        end
    end

    def illust_dir
      @illust_dir ||= "#{@page.illust_id} #{@page.title}"
    end

    def member_dir
      @member_dir ||= "#{@page.member_id} #{@page.member_name}"
    end

    def filename
      @filename ||= begin
        filename =
          if @page.manga?
            "#{@page.page_number}#{extname}"
          else
            "#{@page.illust_id} #{@page.title}#{extname}"
          end
        filename.gsub!('/', '／')
        filename.gsub!(':', '：')
        filename
      end
    end

    def extname
      @extname ||= File.extname(@page.download_url)
    end
  end
end
