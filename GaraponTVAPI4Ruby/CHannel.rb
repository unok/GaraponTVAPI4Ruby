module GaraponTVAPI4Ruby

  class Channel
    attr_accessor :channel
    attr_accessor :channel_name
    attr_accessor :hash_tag

    def initialize (ch, ch_name, hash_tag)
      @channel      = ch
      @channel_name = ch_name
      @hash_tag     = hash_tag
    end
  end

  class ChannelList
    attr_accessor :_channel_list

    def initialize(channel_array = [])
      @_channel_list = []
      channel_array.each { |ch, val|
        @_channel_list.push(Channel.new(ch, val['ch_name'], val['hash_tag']))
      }
    end

    def get_channel_list
      @_channel_list
    end

    def search_by_channel(ch)
      _channel_list.each { |val|
        if val.channel == ch
          return val
        end
      }
      nil
    end

    def search_by_channel_name(name)
      _channel_list.each { |val|
        if val.channel_name == name
          return val
        end
      }
      nil
    end
  end
end