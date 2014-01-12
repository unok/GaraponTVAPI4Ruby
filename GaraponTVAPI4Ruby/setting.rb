module GaraponTVAPI4Ruby
  class Setting
    attr_accessor :user_id
    attr_accessor :password
    attr_accessor :developer_id

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