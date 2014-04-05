# -*- encoding: utf-8 -*-
require 'tweetstream'
require 'twitter'
require './lib/key.rb'
require './lib/bot.rb'

rest = Twitter::REST::Client.new do |config|
  config.consumer_key        = Const::CONSUMER_KEY
  config.consumer_secret     = Const::CONSUMER_SECRET
  config.access_token        = Const::ACCESS_TOKEN
  config.access_token_secret = Const::ACCESS_TOKEN_SECRET
end
TweetStream.configure do |config|
   config.consumer_key        = Const::CONSUMER_KEY
   config.consumer_secret     = Const::CONSUMER_SECRET
   config.oauth_token         = Const::ACCESS_TOKEN
   config.oauth_token_secret  = Const::ACCESS_TOKEN_SECRET
   config.auth_method         = :oauth
end

client = TweetStream::Client.new

client.userstream do |status|
  p status.text
  if status.text.match(/^@ginkomistakejp/i) and !status.text.start_with?("RT")
    ginko = Bot.new
    a = status.text.gsub(/@ginkomistakejp/i, "")
    b = ginko.makeSimilarWord(a)
    c = ginko.makeRelatedWord(b)
    text = "@#{status.user.screen_name} ぎんこさん#{a}と#{b}間違えててワロタｗｗｗｗｗｗｗｗｗｗｗ#{c}ｗｗｗｗｗｗ"
    puts text
    option = {"in_reply_to_status_id"=>status.id.to_s}
    rest.update text,option
  end
end
