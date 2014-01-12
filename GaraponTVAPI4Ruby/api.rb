require 'json'
require 'rubygems'
require 'httpclient'
require 'kconv'

$LOAD_PATH << File.dirname(__FILE__)
require 'setting.rb'
require 'connection_info.rb'
require 'channel.rb'
require 'search.rb'

module GaraponTVAPI4Ruby

  # GaraponTV API ラッパークラス
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

    # 設定情報
    attr_reader :setting
    # 接続情報
    attr_reader :connection_info
    # セッション情報
    attr_reader :session

    public
    
    # 初期化
    # 接続情報と録画チャンネルリストを取得
    def initialize
      @setting = Setting.new
      get_connection_info
      get_channel_list
    end

    # ガラポン端末への接続情報を取得
    # [return]
    # ConnectionInfo
    def get_connection_info
      unless @connection_info.nil?
        return @connection_info
      end

      post_data        = {
          :user      => @setting.user_id,
          :md5passwd => @setting.password,
          :dev_id    => @setting.developer_id
      }
      client           = HTTPClient.new
      response         = client.post_content(GARAPON_WEB_AUTH_URL, post_data)
      @connection_info = ConnectionInfo.new(response)
    end

    # ログイン処理
    # ログインAPIを実行してセッション情報を取得する
    # [arg1]
    # Boolean
    # retry_flag true の時にセッションが存在しても再度接続する
    # [return]
    # true
    def do_login(retry_flag = false)
      unless retry_flag == false && @session == nil
        return true
      end
      url             = get_api_url(API_URL_TYPE_AUTH)
      post_data       = {
          :type    => 'login',
          :loginid => @setting.user_id,
          :md5pswd => @setting.password,
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

      @session = response['gtvsession']

      true
    end

    
    # 録画チャンネル一覧を取得する
    # [return]
    # ChannelList
    def get_channel_list
      if @channel_list != nil
        return @channel_list
      end
      do_login
      url             = get_api_url(API_URL_TYPE_CHANNEL)
      client          = HTTPClient.new
      response_string = client.get_content(url)
      response        = JSON.parse(response_string)
      unless response.has_key?('status')
        raise 'Error: invalid response'
      end
      if response['status'] != 1
        raise "Error: Cannot get channel list status=#{response['status']}"
      end

      @channel_list = ChannelList.new(response['ch_list'])
    end


    # 検索
    # [arg1]
    # SearchCondition
    # [return]
    # SearchResult
    def search(search_condition)
      do_login
      SearchResult.new(get_api_url(API_URL_TYPE_SEARCH), search_condition)
    end

    protected
    
    # 各API用のURLを取得
    # [arg1]
    # url_type API_URL_TYPE_*
    # [return]
    # url 文字列
    def get_api_url(url_type)
      con = get_connection_info

      case url_type
        when API_URL_TYPE_SEARCH then
          return sprintf('http://%s:%s%s?dev_id=%s&gtvsession=%s',
                         con.ip, con.port, API_PATH_SEARCH, @setting.developer_id, get_session)
        when API_URL_TYPE_AUTH then
          return sprintf('http://%s:%s%s?dev_id=%s', con.ip, con.port, API_PATH_AUTH, @setting.developer_id)
        when API_URL_TYPE_CHANNEL then
          return sprintf('http://%s:%s%s?dev_id=%s&gtvsession=%s',
                         con.ip, con.port, API_PATH_CHANNEL, @setting.developer_id, get_session)
        when API_URL_TYPE_FAVORITE then
          return sprintf('http://%s:%s%s?dev_id=%s&gtvsession=%s',
                         con.ip, con.port, API_PATH_FAVORITE, @setting.developer_id, get_session)
        else
          raise "Unknown url type: #{url_type}"
      end
    end

    # セッション取得
    # セッションが存在しなければログインする
    # [return]
    # セッションID
    def get_session
      if @session == nil
        do_login
      end
      @session
    end
  end
end
