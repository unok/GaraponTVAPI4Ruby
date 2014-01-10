#!/usr/bin/env ruby

require './GaraponTVAPI4Ruby/api.rb'

s = GaraponTVAPI4Ruby::GaraponTVAPI4Ruby.new

condition = GaraponTVAPI4Ruby::SearchCondition.new
condition.search_key = 'あまちゃん'
condition.max_program_count = 3
condition.with_detail_flag = false
s.search(condition).each {|item|
  p item
}
