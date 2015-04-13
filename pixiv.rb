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
client.illust_ids(575769)
client.download(49548341) # イラスト
client.download(49777899) # 漫画

=end
