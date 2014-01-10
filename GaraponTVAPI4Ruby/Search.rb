module GaraponTVAPI4Ruby

  class SearchCondition
    attr_accessor :count_par_page
    attr_accessor :page_number
    attr_accessor :search_target
    attr_accessor :search_key
    attr_accessor :program_id
    attr_accessor :program_id_list
    attr_accessor :genre0
    attr_accessor :genre1
    attr_accessor :channel
    attr_accessor :duration_target
    attr_accessor :start_date
    attr_accessor :end_date
    attr_accessor :rank
    attr_accessor :sort_condition
    attr_accessor :video_only_flag

    attr_accessor :with_detail_flag
    attr_accessor :column_mapping_list
    attr_accessor :max_program_count

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
          :video_only_flag => 'video'
      }
      @count_par_page      = 100
      @max_program_count   = nil
      @page_number         = 1
      @duration_target     = 's'
      @sort_condition      = 'std'
      @search_target       = 'e'
    end

    def get_post_data(detail_flag = false)
      data = Hash.new
      if detail_flag
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

  class ProgramInfo
    attr_accessor :program_id
    attr_accessor :start_date
    attr_accessor :duration
    attr_accessor :channel
    attr_accessor :title
    attr_accessor :description
    attr_accessor :favorite_flag
    attr_accessor :genre_list
    attr_accessor :channel_name
    attr_accessor :hash_tag
    attr_accessor :has_video

    attr_accessor :closed_caption_list

    def initialize(program_id, start_date, duration, channel, title, description, favorite_flag, genre, channel_name, hash_tag, has_video, caption)
      @program_id          = program_id
      @start_date          = start_date
      @duration            = duration
      @channel             = channel
      @title               = title
      @description         = description
      @favorite_flag       = favorite_flag
      @channel_name        = channel_name
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

  class SearchResult
    include Enumerable

    attr_accessor :status
    attr_accessor :count
    attr_accessor :version

    attr_accessor :hit_count


    def initialize(url, search_condition)
      @url              = url
      @search_condition = search_condition
      @client           = HTTPClient.new
      @counter          = 0
      @hit_count        = 0

      @client.receive_timeout = 3000
    end

    def each_program_info
      if @search_condition.max_program_count < @search_condition.count_par_page
        @search_condition.count_par_page = @search_condition.max_program_count
      end
      begin
        program_list = _search_program_info(@search_condition)
        program_list.each { |program|
          @counter += 1
          if @search_condition.with_detail_flag
            condition               = SearchCondition.new
            condition.program_id    = program.program_id
            condition.channel       = program.channel
            condition.search_target = 'c'
            program_detail          = _search_program_info(condition, true)
            yield program_detail[0]
          else
            yield program
          end
        }
        @search_condition.page_number += 1
      end while @counter < @search_condition.max_program_count && @counter < @hit_count
    end

    alias each each_program_info

    private
    def _search_program_info(search_condition, detail_search_flag = false)
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
      end
      result_list = []
      response['program'].each { |program|
        result_list.push(ProgramInfo.new(
                             program['gtvid'], program['startdate'], program['duration'], program['ch'], program['title'],
                             program['description'], program['favorite'], program['genre'], program['bc'],
                             program['bc_tags'], program['ts'], program['caption']))
      }
      result_list
    end
  end
end
