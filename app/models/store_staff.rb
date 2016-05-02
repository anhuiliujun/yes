class StoreStaff <  ActiveRecord::Base
  attr_accessor :password, :password_confirmation

  # 是某家门店的店员
  belongs_to :store, dependent: :destroy
  # 是某家连锁店的店员(冗余字段: 通过store可以获得)
  belongs_to :store_chain
  # 是某家连锁店的管理员(冗余关系: 可通过my_store获得)
  has_one :my_chain, class_name: 'StoreChain'
  # 是某家门店的管理员
  has_one :my_store, class_name: 'Store'

  validates :login_name, presence: true, length: {is: 11}, numericality: { only_integer: true }

  validates_presence_of     :password, if: :password_required?

  before_validation :set_full_name
  before_create :encrypt_password, :set_name_display

  def self.encrypt_with_salt(txt, salt)
    Digest::SHA256.hexdigest("#{salt}#{txt}")
  end

  def reset_password(new_password, pass_confirmation)
    self.password = new_password
    self.password_confirmation = pass_confirmation
    encrypt_password
  end

  def reset_password!(new_password, pass_confirmation)
    self.reset_password(new_password, pass_confirmation)
    self.save
  end

  def fullname
    "#{last_name}#{first_name}"
  end

  private
  def set_full_name
    self.full_name = case self.name_display_type
    when 'firstname_pre'
      "#{self.first_name}#{self.last_name}"
    when 'lastname_pre'
      "#{self.last_name}#{self.first_name}"
    else
      "#{self.first_name}#{self.last_name}"
    end
  end

  def encrypt_password()
    self.salt = Digest::MD5.hexdigest("--#{Time.now.to_i}--")
    self.encrypted_password = self.class.encrypt_with_salt(self.password, self.salt)
  end

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  # 默认姓在前
  def set_name_display
    self.name_display_type = 'lastname_pre'
  end

end
