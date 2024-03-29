class User < ApplicationRecord
  #attr_accessorを使って「仮想の」属性を作成
  attr_accessor :remember_token #9.3
  before_save { self.email = email.downcase }
  validates(:name, presence: true, length: { maximum: 50 })
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates(:email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true)
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
  
  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # ランダムなトークンを返す 9.2
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
   # 永続セッションのためにユーザーをデータベースに記憶する 9.3
   #update_attributeは特定のカラムだけをアップデートする
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
   # 渡されたトークンがダイジェストと一致したらtrueを返す 9.6
  def authenticated?(remember_token)
    return false if remember_digest.nil?#9.19 ダイジェストが存在しない場合に対応
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
   # ユーザーのログイン情報を破棄する 9.11
  def forget
    update_attribute(:remember_digest, nil)
  end
end