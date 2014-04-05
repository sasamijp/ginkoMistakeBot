# -*- encoding: utf-8 -*-
require 'bundler/setup'
require 'extractcontent'
require 'levenshtein'
require 'shellwords'
require 'rss'
require 'natto'
require 'twitter'
require './lib/collectnouns.rb'

class Bot

  def initialize
    @natto = Natto::MeCab.new
    @sites = readdata("./lib/data/sites.csv") #　　RSSの取得元を読み込む
    @nouns = readdata("./lib/nouns.csv").uniq #　　抽出しておいた名詞リストを読み込む
    @rest_client = Twitter::REST::Client.new do |config|
      config.consumer_key        = Const::CONSUMER_KEY
      config.consumer_secret     = Const::CONSUMER_SECRET
      config.access_token        = Const::ACCESS_TOKEN
      config.access_token_secret = Const::ACCESS_TOKEN_SECRET
    end
  end

  def makeSimilarWord(word)
    @nouns = extractJapanese(@nouns)　#　　名詞リストから日本語のものだけを抽出
    @nouns.delete_if{|noun| ((noun == word) or !(noun.length == word.length)) }
    nouns = []
    60.times{nouns.push @nouns[-@nouns.length/2,60].sample}
    nouns.sort_by!{|noun|similar(noun, word)}
    return nouns[-1]
  end

  def makeRelatedWord(word)
    words = []
    searchforTweets(word).each do |tweet|
      words.push extractNouns(tweet)
    end
    words.flatten!.compact!
    words.delete_if{|noun| noun == word}
    words.sort_by!{|noun| noun.length }
    return words[-1]
  end

  private

  def extractNouns(str)
    nouns = []
    @natto.parse(str) do |word|
      nouns.push(word.surface) if word.feature.split(",")[0] == '名詞'
    end
    return nouns
  end

  def extractJapanese(array)
    array.delete_if{|word| !(word =~ /(?:\p{Hiragana}|\p{Katakana}|[一-龠々])/)}
    return array
  end

  def readdata(filename)
    return File.read(filename, :encoding => Encoding::UTF_8).split("\n")
  end

  def toKatakana(str)
    safe_str = str.gsub(/[!-\/:-@\[-`{-~] /, '').strip.shellescape
    `echo #{safe_str} | nkf -e | kakasi.dSYM -JK -HK | nkf -w`
  end

  def similar(s1, s2)
    return Levenshtein.distance(toKatakana(s1), toKatakana(s2))
  end

  def searchforTweets(str)
    result = []
    @rest_client.search(str, :result_type => "latest").take(100).each do |status|
      next if !status.text.start_with?(str) or status.text.include?("RT") or status.text.include?("http") or status.text.include?(".co") or status.text.include?("@")
      result.push(status.text)
    end
    return result
  end

end

#bot = Bot.new
#b = bot.makeSimilarWord(gets.chomp)
#c = bot.makeRelatedWord(b)
#puts b
#puts c


