module UsersHelper

  def gravatar_for(user, size: 50)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)#digestメソッドでemailをMD5ハッシュ
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"#ハッシュ化されたidをgravatarに紐つける
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
