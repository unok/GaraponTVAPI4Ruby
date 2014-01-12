GaraponTVAPI4Ruby
=================

Setting
-----------

make developer_info.json

    {"user_id":"login_user_id","password":"md5sum for password","developer_id":"garapon developer id"}

Example
------------

search

    require './GaraponTVAPI4Ruby/api.rb'
    
    api_wrapper = GaraponTVAPI4Ruby::GaraponTVAPI4Ruby.new
    
    condition = GaraponTVAPI4Ruby::SearchCondition.new
    condition.search_key        = 'あまちゃん'
    condition.max_program_count = 2
    condition.with_detail_flag  = true
    api_wrapper.search(condition).each {|program|
      p program
    }
    
