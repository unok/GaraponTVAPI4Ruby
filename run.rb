#!/usr/bin/env ruby

require './GaraponTVAPI4Ruby/api.rb'

s = GaraponTVAPI4Ruby::GaraponTVAPI4Ruby.new('./developer_info.json')

condition = GaraponTVAPI4Ruby::SearchCondition.new
condition.search_key = 'あまちゃん'
condition.max_program_count = 2
condition.with_detail_flag = true
s.search(condition).each {|program|
  p program
}

p s.get_channel_list

p s.setting
p s.connection_info
