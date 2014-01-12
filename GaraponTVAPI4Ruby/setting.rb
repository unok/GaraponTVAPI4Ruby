module GaraponTVAPI4Ruby
=begin rdoc
Garapon Web への接続情報を管理するクラス
=end
  class Setting
    # ログインするための ID
    attr_accessor :user_id
    # ログインするためのパスワードの md5sum
    attr_accessor :password
    # API を利用するための Garapon TV から付与された開発者ID
    attr_accessor :developer_id

    # データを developer_info.json から読み込む
    # 書式は developer_info.json.sample を参照してください
    def initialize(ini_path = 'developer_info.json')
      @data_field_list = %w/user_id password developer_id/
      unless File.exists?(ini_path)
        raise 'File not found: ' + ini_path
      end
      json = File.readlines(ini_path).join('')
      data = JSON.parse(json)
      @data_field_list.each { |key|
        unless data.has_key?(key)
          raise "Not found #{key}"
        end
        eval "@#{key} = data[key]"
      }
    end
  end
end