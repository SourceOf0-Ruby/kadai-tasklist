module TasksHelper
  
  # status用文字列とbootstrap用class文字列のハッシュを取得する
  def state_class_hash
    @state_class_hash = {
      "新規"   => "info",
      "未着手" => "warning",
      "着手"   => "primary",
      "遅延"   => "danger",
      "保留"   => "info",
      "取消"   => "default",
      "完了"   => "success"
    };
  end
  
  # カラムstatusに格納する文字列一覧を取得する
  def state_list
    return @state_list = state_class_hash.keys;
  end

end
