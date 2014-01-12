var search_data = {"index":{"searchIndex":["garapontvapi4ruby","channel","channellist","connectioninfo","garapontvapi4ruby","programinfo","searchcondition","searchresult","setting","do_login()","each()","each_program_info()","get_api_url()","get_channel_list()","get_channel_list()","get_connection_info()","get_post_data()","get_session()","new()","new()","new()","new()","new()","new()","new()","new()","search()","search_by_channel()","search_by_channel_name()","search_program_info()","size()","created.rid"],"longSearchIndex":["garapontvapi4ruby","garapontvapi4ruby::channel","garapontvapi4ruby::channellist","garapontvapi4ruby::connectioninfo","garapontvapi4ruby::garapontvapi4ruby","garapontvapi4ruby::programinfo","garapontvapi4ruby::searchcondition","garapontvapi4ruby::searchresult","garapontvapi4ruby::setting","garapontvapi4ruby::garapontvapi4ruby#do_login()","garapontvapi4ruby::searchresult#each()","garapontvapi4ruby::searchresult#each_program_info()","garapontvapi4ruby::garapontvapi4ruby#get_api_url()","garapontvapi4ruby::channellist#get_channel_list()","garapontvapi4ruby::garapontvapi4ruby#get_channel_list()","garapontvapi4ruby::garapontvapi4ruby#get_connection_info()","garapontvapi4ruby::searchcondition#get_post_data()","garapontvapi4ruby::garapontvapi4ruby#get_session()","garapontvapi4ruby::channel::new()","garapontvapi4ruby::channellist::new()","garapontvapi4ruby::connectioninfo::new()","garapontvapi4ruby::garapontvapi4ruby::new()","garapontvapi4ruby::programinfo::new()","garapontvapi4ruby::searchcondition::new()","garapontvapi4ruby::searchresult::new()","garapontvapi4ruby::setting::new()","garapontvapi4ruby::garapontvapi4ruby#search()","garapontvapi4ruby::channellist#search_by_channel()","garapontvapi4ruby::channellist#search_by_channel_name()","garapontvapi4ruby::searchresult#search_program_info()","garapontvapi4ruby::searchresult#size()",""],"info":[["GaraponTVAPI4Ruby","","GaraponTVAPI4Ruby.html","",""],["GaraponTVAPI4Ruby::Channel","","GaraponTVAPI4Ruby/Channel.html","","<p>チャンネル情報管理クラス\n"],["GaraponTVAPI4Ruby::ChannelList","","GaraponTVAPI4Ruby/ChannelList.html","","<p>チャンネル情報リスト管理クラス\n"],["GaraponTVAPI4Ruby::ConnectionInfo","","GaraponTVAPI4Ruby/ConnectionInfo.html","","<p>接続情報管理クラス\n"],["GaraponTVAPI4Ruby::GaraponTVAPI4Ruby","","GaraponTVAPI4Ruby/GaraponTVAPI4Ruby.html","","<p>GaraponTV API ラッパークラス\n"],["GaraponTVAPI4Ruby::ProgramInfo","","GaraponTVAPI4Ruby/ProgramInfo.html","","<p>番組情報\n"],["GaraponTVAPI4Ruby::SearchCondition","","GaraponTVAPI4Ruby/SearchCondition.html","","<p>検索条件管理クラス\n<p>例:\n\n<pre>d = SearchCondition.new\n\nd.search_key    = &#39;あまちゃん&#39;\nd.search_target = &#39;c&#39;\nd.start_date    = ...</pre>\n"],["GaraponTVAPI4Ruby::SearchResult","","GaraponTVAPI4Ruby/SearchResult.html","","<p>検索結果管理テーブル\n"],["GaraponTVAPI4Ruby::Setting","","GaraponTVAPI4Ruby/Setting.html","","<p>Garapon Web への接続情報を管理するクラス\n"],["do_login","GaraponTVAPI4Ruby::GaraponTVAPI4Ruby","GaraponTVAPI4Ruby/GaraponTVAPI4Ruby.html#method-i-do_login","(retry_flag = false)","<p>ログイン処理 ログインAPIを実行してセッション情報を取得する\n<p>arg1 &mdash; Boolean retry_flag true の時にセッションが存在しても再度接続する\n<p>return &mdash; true\n"],["each","GaraponTVAPI4Ruby::SearchResult","GaraponTVAPI4Ruby/SearchResult.html#method-i-each","()",""],["each_program_info","GaraponTVAPI4Ruby::SearchResult","GaraponTVAPI4Ruby/SearchResult.html#method-i-each_program_info","()","<p>each 時に使われる処理 自動でページ送りと詳細情報取得処理を実施する\n"],["get_api_url","GaraponTVAPI4Ruby::GaraponTVAPI4Ruby","GaraponTVAPI4Ruby/GaraponTVAPI4Ruby.html#method-i-get_api_url","(url_type)","<p>各API用のURLを取得\n<p>arg1 &mdash; url_type API_URL_TYPE_*\n<p>return &mdash; url 文字列\n"],["get_channel_list","GaraponTVAPI4Ruby::ChannelList","GaraponTVAPI4Ruby/ChannelList.html#method-i-get_channel_list","()","<p>チャンネル情報のリストを返す\n"],["get_channel_list","GaraponTVAPI4Ruby::GaraponTVAPI4Ruby","GaraponTVAPI4Ruby/GaraponTVAPI4Ruby.html#method-i-get_channel_list","()","<p>録画チャンネル一覧を取得する\n<p>return &mdash; ChannelList\n\n"],["get_connection_info","GaraponTVAPI4Ruby::GaraponTVAPI4Ruby","GaraponTVAPI4Ruby/GaraponTVAPI4Ruby.html#method-i-get_connection_info","()","<p>ガラポン端末への接続情報を取得\n<p>return &mdash; ConnectionInfo\n\n"],["get_post_data","GaraponTVAPI4Ruby::SearchCondition","GaraponTVAPI4Ruby/SearchCondition.html#method-i-get_post_data","(detail_flag = false)","<p>HTTPClient の post_data 時の post に使う価を取得する\n"],["get_session","GaraponTVAPI4Ruby::GaraponTVAPI4Ruby","GaraponTVAPI4Ruby/GaraponTVAPI4Ruby.html#method-i-get_session","()","<p>セッション取得 セッションが存在しなければログインする\n<p>return &mdash; セッションID\n\n"],["new","GaraponTVAPI4Ruby::Channel","GaraponTVAPI4Ruby/Channel.html#method-c-new","(ch, ch_name, hash_tag)","<p>初期化処理\n"],["new","GaraponTVAPI4Ruby::ChannelList","GaraponTVAPI4Ruby/ChannelList.html#method-c-new","(channel_array = [])","<p>初期化処理\n"],["new","GaraponTVAPI4Ruby::ConnectionInfo","GaraponTVAPI4Ruby/ConnectionInfo.html#method-c-new","(string)","<p>初期化処理 接続情報から情報を取得\n"],["new","GaraponTVAPI4Ruby::GaraponTVAPI4Ruby","GaraponTVAPI4Ruby/GaraponTVAPI4Ruby.html#method-c-new","()","<p>初期化 接続情報と録画チャンネルリストを取得\n"],["new","GaraponTVAPI4Ruby::ProgramInfo","GaraponTVAPI4Ruby/ProgramInfo.html#method-c-new","( program_id, start_date, duration, channel, title, description, favorite_flag, genre, channel_name, hash_tag, has_video, caption)","<p>初期化\n"],["new","GaraponTVAPI4Ruby::SearchCondition","GaraponTVAPI4Ruby/SearchCondition.html#method-c-new","()","<p>初期化処理 初期値と API とのキーマッピングを設定する\n"],["new","GaraponTVAPI4Ruby::SearchResult","GaraponTVAPI4Ruby/SearchResult.html#method-c-new","(url, search_condition)","<p>初期化\n"],["new","GaraponTVAPI4Ruby::Setting","GaraponTVAPI4Ruby/Setting.html#method-c-new","(ini_path = 'developer_info.json')","<p>データを developer_info.json から読み込む 書式は developer_info.json.sample を参照してください\n"],["search","GaraponTVAPI4Ruby::GaraponTVAPI4Ruby","GaraponTVAPI4Ruby/GaraponTVAPI4Ruby.html#method-i-search","(search_condition)","<p>検索\n<p>arg1 &mdash; SearchCondition\n<p>return &mdash; SearchResult\n"],["search_by_channel","GaraponTVAPI4Ruby::ChannelList","GaraponTVAPI4Ruby/ChannelList.html#method-i-search_by_channel","(ch)","<p>チャンネルID で検索\n"],["search_by_channel_name","GaraponTVAPI4Ruby::ChannelList","GaraponTVAPI4Ruby/ChannelList.html#method-i-search_by_channel_name","(name)","<p>チャンネル名で検索\n"],["search_program_info","GaraponTVAPI4Ruby::SearchResult","GaraponTVAPI4Ruby/SearchResult.html#method-i-search_program_info","(search_condition, detail_search_flag = false)","<p>実際の検索 API を呼ぶ処理\n"],["size","GaraponTVAPI4Ruby::SearchResult","GaraponTVAPI4Ruby/SearchResult.html#method-i-size","()","<p>結果件数取得\n"],["created.rid","","doc/created_rid.html","",""]]}}