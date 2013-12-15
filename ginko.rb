# -*- encoding: utf-8 -*-
require 'rubygems'
require 'tweetstream'
require 'twitter'
require 'bimyou_segmenter'
require './key.rb'
require './rss.rb'
require './kazoo.rb'
require 'weather_jp'

Twitter.configure do |config|
   config.consumer_key        = Const::CONSUMER_KEY
   config.consumer_secret     = Const::CONSUMER_SECRET
   config.oauth_token            = Const::ACCESS_TOKEN
   config.oauth_token_secret  = Const::ACCESS_TOKEN_SECRET
end

TweetStream.configure do |config|
   config.consumer_key        =  ""
   config.consumer_secret     =""
   config.oauth_token            = ""
   config.oauth_token_secret  = ""
   config.auth_method            = :oauth
end

client = TweetStream::Client.new
array = Rss::ARR
arrayc = Rss::ARRY
#puts array
client.userstream do |status|
  if status.text.include?("@GinkoMistakeJP") && !status.text.include?("RT") then
    textw = status.text.sub("@GinkoMistakeJP ","")
    tenkitx = "@#{status.user.screen_name} ぎんこさんテンキーと天気間違えて天気調べててワロタｗｗｗ#{WeatherJp.parse textw}ｗｗｗｗｗｗｗ"
    option = {"in_reply_to_status_id"=>status.id.to_s}
    Twitter.update tenkitx,option
  end 
  
 if status.user.screen_name != "GinkoMistakeJP" && status.user.screen_name == "murakamiginko" then

  x = BimyouSegmenter.segment(status.text)
  len=[0]
  n=0
  latest = x[0]
  for var in x do
    len[n] = var.length
    n+=1
  end
  mx = len.max
  for var in x do
    if var.length == mx.to_i then
      a = var
    end
  end

  num = 0
  similar=[0]
  for var in array do
    similar[num] = penis(a,var)
    num += 1
  end
  min = similar.min
  for var in array do
    si = penis(a,var)
    if min == si then
      ret = var
    end
  end

  numc = 0
  similarc = [0]
  for var in arrayc do
    similarc[numc] = penis(a,var)
    numc += 1
  end
  minc = similarc.min
  for var in arrayc do
    if var.to_i == 0 then
    sic = penis(a,var)
      if minc == sic then
        retc = var
        break
      end
    end
  end

  bb = ret
  cc = retc

  if status.user.screen_name != "murakamiginko" then
    text = "#{status.user.screen_name}さん#{a}と#{bb}間違えててワロタｗｗｗｗｗｗｗｗｗｗ#{cc}ｗｗｗｗｗｗｗｗｗｗｗｗｗｗ"
  else
    text = "ぎんこさん#{a}と#{bb}間違えててワロタｗｗｗｗｗｗｗｗｗｗ#{cc}ｗｗｗｗｗｗｗｗｗｗｗｗｗｗ"
  end
  Twitter.update text
  puts text
 end
end
