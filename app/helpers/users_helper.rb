module UsersHelper
  
  # Gravatar(https://ja.gravatar.com/)に登録されている画像のurlを取得する
  # @param user: 対象のユーザのモデルインスタンス
  # @param options: Gravatarの仕様に沿って追加するオプションの内容
  #                 size: URL?s=[size] サイズ指定、1～2048pxまで
  def gravatar_url(user, options = { size: 80 })
    # 小文字のみメアドをMD5でハッシュに変換
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase);
    size = options[:size];
    return "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}";
  end
  
end
