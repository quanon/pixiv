require './pixiv/page/base'
require './pixiv/page/works'
require './pixiv/page/illust/base'
require './pixiv/page/illust/medium'
require './pixiv/page/illust/manga'
require './pixiv/page/illust/manga_big'
require './pixiv/downloader'
require './pixiv/client'

=begin

require './pixiv'

client = Pixiv::Client.new
client.login

client.download(illust_id) # イラスト
client.download(illust_id) # 漫画
client.download_all(member_id) # 一括ダウンロード

=end
