# -*- encoding: utf-8 -*-
require 'rubygems'
require 'levenshtein'
require 'shellwords'

def similar(s1, s2, threshold = 2)
  d = Levenshtein.distance(toKatakana(s1), toKatakana(s2))
  d <= threshold
end


def toKatakana(str)
  safe_str = str.gsub(/[!-\/:-@\[-`{-~] /, '').strip.shellescape
  `echo #{safe_str} | nkf -e | kakasi.dSYM -JK -HK | nkf -w`
end
def penis(s1, s2)
  return Levenshtein.distance(toKatakana(s1), toKatakana(s2))
end
#puts penis("ちんこ","まんこ")
s1 = "銀行"
s2 = "ぎんこ"

#if similar(s1, s2)
#  puts "ぎんこさん#{s1}と#{s2}間違えててワロタwww" if similar(s1, s2)
#end
