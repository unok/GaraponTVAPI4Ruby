module GaraponTVAPI4Ruby

  # 接続情報管理クラス
  class ConnectionInfo
    attr_reader :ip
    attr_reader :global_ip
    attr_reader :private_ip
    attr_reader :port
    attr_reader :ts_port
    attr_reader :version

    # 初期化処理
    # 接続情報から情報を取得
    def initialize(string)
      string.each_line { |line|
        key, val = line.chomp.split(';')
        case key
          when 1 then
            raise "Error: #{val}"
          when 'ipaddr' then
            @ip = val
          when 'gipaddr' then
            @global_ip = val
          when 'pipaddr' then
            @private_ip = val
          when 'port' then
            @port = val
          when 'port2' then
            @ts_port = val
          when 'gtvver' then
            @version = val
          when '0' then
            next
          else
            raise "WARNING: unknown response: #{key}  = #{val}"
        end
      }
    end
  end
end