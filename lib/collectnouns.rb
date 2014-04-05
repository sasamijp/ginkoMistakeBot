# -*- encoding: utf-8 -*-
require 'bundler/setup'
require 'extractcontent'
require 'rss'
require 'natto'

class Collectnouns

  def initialize
    @natto = Natto::MeCab.new
    @sites = readRSSdata("./data/sites.csv")
  end

  def collectfromRSS
    nouns = []
    @sites.each do |site|
      getitems(site).each do |item|
        extractBody(item['url']).each do |str|
          nouns.push extractNouns(str)
        end
      end
    end
    return nouns
  end

  def collectfromWebSite(url)
    nouns = []
    extractBody(url).each do |str|
      nouns.push extractNouns(str)
    end
    return nouns
  end

  def readRSSdata(filename)
    return File.read(filename, :encoding => Encoding::UTF_8).split("\n")
  end

  def extractNouns(str)
    nouns = []
    @natto.parse(str) do |word|
      nouns.push(word.surface) if word.feature.split(",")[0] == '名詞'
    end
    return nouns
  end

  def extractBody(url)
    open(url, "r:utf-8") do |io|
      html = io.read
      body, title = ExtractContent.analyse(html)
      strs = []
      body.split("  ").each do |str|
        strs.push(str)
      end
      return strs
    end
  end

  def getitems(url)
    rss = RSS::Parser.parse(url)
    items = []
    rss.items.each do |item|
      value = {
        'title' => item.title,
        'url' => item.link
      }
      items.push value
    end
    return items
  end

end

#collecter = Collectnouns.new
#puts collecter.collectfromRSS
