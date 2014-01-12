module GaraponTVAPI4Ruby

  class ConnectionInfo
    attr_accessor :ip
    attr_accessor :global_ip
    attr_accessor :private_ip
    attr_accessor :port
    attr_accessor :ts_port
    attr_accessor :version

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