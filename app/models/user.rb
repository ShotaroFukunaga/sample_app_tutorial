class User < ApplicationRecord
  validates :name, presence: true,  length: { maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  #正規表現で記号のマッチングを行う
  validates :email, presence: true, length: { maximum: 255},format: { with: VALID_EMAIL_REGEX },
                                                            uniqueness: { case_sensitive: false }
  #メールアドレスの大文字小文字は無視した検証を行なっているためcase_sensitive: false

end
