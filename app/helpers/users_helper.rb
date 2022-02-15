module UsersHelper

  def gravatar_for(user)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)#digestメソッドでemailをMD5ハッシュ
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"#ハッシュ化されたidをgravatarに紐つける
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
