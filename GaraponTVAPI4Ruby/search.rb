module GaraponTVAPI4Ruby
=begin rdoc
検索条件管理クラス

例:
  d = SearchCondition.new

  d.search_key    = 'あまちゃん'
  d.search_target = 'c'
  d.start_date    = '2013-12-30 00:00:00'
  d.end_date      = '2013-12-31 23:59:59'

=end
  class SearchCondition
    # API検索時の 1 ページ毎の件数(default 100, max 100)
    # @max_program_count の方が小さい場合は @max_program_count の価が使われる
    attr_accessor :count_par_page
    # API検索時のページ番号
    attr_accessor :page_number
    # 検索対象 (e: EPG, c: 字幕)
    attr_accessor :search_target
    # 検索する文字
    attr_accessor :search_key
    # 検索する番組ID
    attr_accessor :program_id
    # 検索する番組ID のリスト
    attr_accessor :program_id_list
    # 検索する大ジャンルID
    attr_accessor :genre0
    # 検索する小ジャンルID
    attr_accessor :genre1
    # 検索するチャンネルのID
    attr_accessor :channel
    # 時間範囲の hit 判定(s: 開始時間が含まれる, e: 終了時間が含まれる)
    attr_accessor :duration_target
    # 検索する時間帯の開始時刻 YYYY-MM-DD hh:mm:ss
    attr_accessor :start_date
    # 検索する時間帯の終了時刻 YYYY-MM-DD hh:mm:ss
    attr_accessor :end_date
    # お気に入りを取得する (all のみ)
    attr_accessor :rank
    # ソート順(std:開始時刻の降順, sta: 開始時間の昇順)
    attr_accessor :sort_condition
    # ビデオがあるものを取得する EPG 検索時のみ有効 (all のみ)
    attr_accessor :has_video_flag

    # caption 全部取得する(個別検索が自動で実施される)
    attr_accessor :with_detail_flag

    # 最大結果取得件数
    attr_accessor :max_program_count

    # 初期化処理
    # 初期値と API とのキーマッピングを設定する
    def initialize
      @column_mapping_list = {
          :count_par_page  => 'n',
          :page_number     => 'p',
          :search_target   => 's',
          :search_key      => 'key',
          :program_id      => 'gtvid',
          :program_id_list => 'gtvidlist',
          :genre0          => 'genre0',
          :genre1          => 'genre1',
          :channel         => 'ch',
          :duration_target => 'dt',
          :start_date      => 'sdate',
          :end_date        => 'edate',
          :rank            => 'rank',
          :sort_condition  => 'sort',
          :has_video_flag  => 'video'
      }
      @count_par_page      = 100
      @max_program_count   = nil
      @page_number         = 1
      @duration_target     = 's'
      @sort_condition      = 'std'
      @search_target       = 'e'
    end

    # HTTPClient の post_data 時の post に使う価を取得する
    def get_post_data(detail_flag = false)
      data = Hash.new
      if detail_flag
        unless instance_variable_defined?(:@program_id)
          raise 'Error: program_id not found'
        end
        data[@column_mapping_list[:program_id]] = @program_id
        return data
      end
      instance_variables.each { |var|
        if var == :@column_mapping_list || var == :@with_detail_flag || var == :max_program_count
          next
        end
        val = instance_variable_get(var)
        eval("data[@column_mapping_list[:#{var.to_s.tr('@', '')}]] = val")
      }
      data
    end
  end

  # 番組情報
  class ProgramInfo
    # 番組ID
    attr_reader :program_id
    # 番組開始時刻
    attr_reader :start_date
    # 番組時間
    attr_reader :duration
    # チャンネルID
    attr_reader :channel
    # 放送局名
    attr_reader :broadcast_station
    # 番組名
    attr_reader :title
    # 詳細 
    attr_reader :description
    # お気に入り
    attr_reader :favorite_flag
    # 所属ジャンル
    attr_reader :genre_list
    # twitter ハッシュタグ
    attr_reader :hash_tag
    # ビデオがあるかどうか
    attr_reader :has_video

    # 字幕情報
    attr_reader :closed_caption_list

    # 初期化
    def initialize(
        program_id, start_date, duration, channel, title, description, favorite_flag, genre, channel_name,
            hash_tag, has_video, caption)
      @program_id          = program_id
      @start_date          = start_date
      @duration            = duration
      @channel             = channel
      @title               = title
      @description         = description
      @favorite_flag       = favorite_flag
      @broadcast_station   = channel_name
      @hash_tag            = hash_tag
      @has_video           = has_video
      @closed_caption_list = caption


      @genre_list = []
      genre.each { |genre_string|
        genre_item = genre_string.split('/')
        @genre_list.push(genre_item)
      }
    end
  end

  # 検索結果管理テーブル
  class SearchResult
    include Enumerable

    # 結果の端末のソフトウェアバージョン
    attr_accessor :version
    # 検索結果の件数
    attr_accessor :hit_count

    # 初期化
    def initialize(url, search_condition)
      @url              = url
      @search_condition = search_condition
      @client           = HTTPClient.new
      @counter          = 0
      @hit_count        = 0

      @client.receive_timeout = 3000
    end

    # each 時に使われる処理
    # 自動でページ送りと詳細情報取得処理を実施する
    def each_program_info
      if @search_condition.max_program_count < @search_condition.count_par_page
        @search_condition.count_par_page = @search_condition.max_program_count
      end
      begin
        program_list = search_program_info(@search_condition)
        program_list.each { |program|
          @counter += 1
          if @search_condition.with_detail_flag
            condition               = SearchCondition.new
            condition.program_id    = program.program_id
            condition.channel       = program.channel
            condition.search_target = 'c'
            program_detail          = search_program_info(condition, true)
            yield program_detail[0]
          else
            yield program
          end
        }
        @search_condition.page_number += 1
      end while @counter < @search_condition.max_program_count && @counter < @hit_count
    end

    alias each each_program_info
    
    # 結果件数取得
    def size
      unless @hit_count >= 0
        search_program_info(@search_condition)
      end
      @hit_count
    end

    protected
    
    # 実際の検索 API を呼ぶ処理
    def search_program_info(search_condition, detail_search_flag = false)
      response_string = @client.post_content(@url, search_condition.get_post_data(detail_search_flag))
      response        = JSON.parse(response_string)
      unless response.has_key?('status')
        raise 'Error: Not found status';
      end
      if response['status'] != 1
        raise "Error: Cannot get response for search: status=#{response['status']}"
      end
      unless response.has_key?('hit')
        raise 'Error: Not found hit';
      end
      unless response.has_key?('program')
        raise 'Error: Not found program';
      end
      unless detail_search_flag
        @hit_count = response['hit'].to_i
        @version = response['version']
      end
      result_list = []
      response['program'].each { |program|
        result_list.push(ProgramInfo.new(
                             program['gtvid'], program['startdate'], program['duration'], program['ch'],
                             program['title'], program['description'], program['favorite'], program['genre'],
                             program['bc'], program['bc_tags'], program['ts'], program['caption']))
      }
      result_list
    end
  end
end
