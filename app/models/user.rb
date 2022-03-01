class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token
  before_save   :downcase_email
  before_create :create_activation_digest#保存を行う前にdowncaseしたアドレスをメソッドに代入している
  validates :name, presence: true,  length: { maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i#正規表現で記号のマッチングを行う
  validates :email, presence: true, length: { maximum: 255},format: { with: VALID_EMAIL_REGEX },
                                                            uniqueness: { case_sensitive: false }
  #メールアドレスの大文字小文字は無視した検証を行なっているためcase_sensitive: false
  has_secure_password#Gem_bcryptのメソッド,password属性とpassword_confirmation属性に対してバリデーションをする機能
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  #渡された文字列のハッシュを返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :#メソッドや定数を呼び出す
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  private

    def downcase_email
      self.email = email.downcase
    end

    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
