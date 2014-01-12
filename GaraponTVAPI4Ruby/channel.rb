module GaraponTVAPI4Ruby
  # チャンネル情報管理クラス
  class Channel
    attr_reader :channel
    attr_reader :channel_name
    attr_reader :hash_tag

    # 初期化処理
    def initialize (ch, ch_name, hash_tag)
      @channel      = ch
      @channel_name = ch_name
      @hash_tag     = hash_tag
    end
  end

  # チャンネル情報リスト管理クラス
  class ChannelList

    # 初期化処理
    def initialize(channel_array = [])
      @channel_list = []
      channel_array.each { |ch, val|
        @channel_list.push(Channel.new(ch, val['ch_name'], val['hash_tag']))
      }
    end

    # チャンネル情報のリストを返す
    def get_channel_list
      @channel_list
    end

    # チャンネルID で検索
    def search_by_channel(ch)
      channel_list.each { |val|
        if val.channel == ch
          return val
        end
      }
      nil
    end

    # チャンネル名で検索
    def search_by_channel_name(name)
      channel_list.each { |val|
        if val.channel_name == name
          return val
        end
      }
      nil
    end
  end
end