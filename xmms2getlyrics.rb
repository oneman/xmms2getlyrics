#!/usr/bin/env ruby
#
# xmms2 ruby get lyrics and push them to stdout
#
# wrotted by David Richards
#
# som kodes maybe have been robbed from: 
# http://crayz.org/2009/1/1/fetching-itunes-lyrics
#
# license is give me some money please :D 
#
# http://rawdod.com
#
# http://github.com/oneman

CLIENT = "xmms2rglptts"
CLIENTVERSION = "0.1 Public Alpha"

require "xmmsclient"

xc = Xmms::Client.new(CLIENT)
xc.connect

%w(rubygems open-uri hpricot).each { |dep| require dep }
BASE_URL = "http://lyricwiki.org"

playback_id = xc.playback_current_id.wait.value
res = xc.medialib_get_info(playback_id).wait
current_track = res.value

artist, song = [current_track[:artist], current_track[:title]].map{ |s| s.gsub(' ', '_') }

page = Hpricot(open("#{BASE_URL}/#{artist}:#{song}")) rescue false
if page
 lyrics_search = (page/"div.lyricbox")
 if lyrics_search.size == 1
  lyrics_box = lyrics_search.first
  lyrics_box.inner_html = lyrics_box.inner_html.gsub("<br />", "\n") 
  lyrics = lyrics_box.inner_text.strip
  #puts "#{artist}:#{song}\n\n#{lyrics}\n\n" + ('-' * 10)
  puts lyrics
  end
end

