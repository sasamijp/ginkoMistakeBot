# -*- encoding: utf-8 -*-
require 'bimyou_segmenter'
require 'rss'
class Rss
TEST = "testtest"
 
filename = 'http://feed.rssad.jp/rss/gigazine/rss_2.0'
rss = RSS::Parser.parse(filename)
b = [0]
c = [0]
num = 0
rss.items.each{|item|
  title = item.title
    x = BimyouSegmenter.segment(title)
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
      b[num] = var
    end
  end
  description = item.description
  x = BimyouSegmenter.segment(description)
  numb=0
  lengt = [0]

  for var in x do
    lengt[numb] = var.length
    numb+=1
  end
  mx = lengt.max
  for var in x do
    if var.length == mx.to_i then
      c[num] = var
    end
  end
  num += 1
}
ARR = b
ARRY =c

end
