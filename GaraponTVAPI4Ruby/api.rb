require 'json'
require 'rubygems'
require 'httpclient'
require 'kconv'

$LOAD_PATH << File.dirname(__FILE__)
require 'Setting.rb'
require 'ConnectionInfo.rb'
require 'Channel.rb'
require 'Search.rb'

module GaraponTVAPI4Ruby

  class GaraponTVAPI4Ruby
    GARAPON_WEB_AUTH_URL = 'http://garagw.garapon.info/getgtvaddress'

    API_PATH_AUTH     = '/gapi/v3/auth'
    API_PATH_SEARCH   = '/gapi/v3/search'
    API_PATH_FAVORITE = '/gapi/v3/favorite'
    API_PATH_CHANNEL  = '/gapi/v3/channel'

    API_URL_TYPE_AUTH     = 'auth'
    API_URL_TYPE_SEARCH   = 'search'
    API_URL_TYPE_FAVORITE = 'favorite'
    API_URL_TYPE_CHANNEL  = 'channel'

    attr_accessor :_setting
    attr_accessor :_connection_info
    attr_accessor :_session
    attr_accessor :_channel_list

    public
    def initialize
      @_setting = Setting.new
      get_connection_info
      get_channel_list
    end

    def get_connection_info
      unless @_connection_info.nil?
        return @_connection_info
      end

      post_data         = {
          :user      => @_setting.user_id,
          :md5passwd => @_setting.password,
          :dev_id    => @_setting.developer_id
      }
      client            = HTTPClient.new
      response          = client.post_content(GARAPON_WEB_AUTH_URL, post_data)
      @_connection_info = ConnectionInfo.new(response)
    end

    def do_login(retry_flag = false)
      unless retry_flag == false && @_session == nil
        return true
      end
      url             = _get_api_url(API_URL_TYPE_AUTH)
      post_data       = {
          :type    => 'login',
          :loginid => @_setting.user_id,
          :md5pswd => @_setting.password,
      }
      client          = HTTPClient.new
      response_string = client.post_content(url, post_data)
      response        = JSON.parse(response_string)
      unless response.has_key?('status') && response.has_key?('login')
        raise 'Error: Not found login status'
      end
      if response['status'] != 1 || response['login'] != 1
        raise "Error: Cannot login status=#{response['status']}, login=#{response['login']}"
      end

      @_session = response['gtvsession']

      true
    end

    def get_channel_list
      if @_channel_list != nil
        return @_channel_list
      end
      do_login
      url             = _get_api_url(API_URL_TYPE_CHANNEL)
      client          = HTTPClient.new
      response_string = client.get_content(url)
      response        = JSON.parse(response_string)
      unless response.has_key?('status')
        raise 'Error: invalid response'
      end
      if response['status'] != 1
        raise "Error: Cannot get channel list status=#{response['status']}"
      end

      @_channel_list = ChannelList.new(response['ch_list'])
    end


    def search(search_condition)
      do_login
      SearchResult.new(_get_api_url(API_URL_TYPE_SEARCH), search_condition)
    end

    private
    def _get_api_url(url_type)
      con = get_connection_info

      case url_type
        when API_URL_TYPE_SEARCH then
          return sprintf('http://%s:%s%s?dev_id=%s&gtvsession=%s',
                         con.ip, con.port, API_PATH_SEARCH, @_setting.developer_id, _get_session)
        when API_URL_TYPE_AUTH then
          return sprintf('http://%s:%s%s?dev_id=%s', con.ip, con.port, API_PATH_AUTH, @_setting.developer_id)
        when API_URL_TYPE_CHANNEL then
          return sprintf('http://%s:%s%s?dev_id=%s&gtvsession=%s',
                         con.ip, con.port, API_PATH_CHANNEL, @_setting.developer_id, _get_session)
        when API_URL_TYPE_FAVORITE then
          return sprintf('http://%s:%s%s?dev_id=%s&gtvsession=%s',
                         con.ip, con.port, API_PATH_FAVORITE, @_setting.developer_id, _get_session)
        else
          raise "Unknown url type: #{url_type}"
      end
    end

    def _get_session
      if @_session == nil
        do_login
      end
      @_session
    end

  end
end
