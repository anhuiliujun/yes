class Staffer < ActiveRecord::Base
  # belongs_to :role, counter_cache: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_one :agent, dependent: :destroy

  devise :database_authenticatable, :timeoutable,
         :rememberable, :trackable, :validatable

 validates :login_name, presence: true, uniqueness: true, format: { with:  /(^\S+$)/ ,
 message: ' '}

 accepts_nested_attributes_for :agent

 ROLE = {
    '1' => '超级管理员',
    '2' => '经销商'
 }

  def toggle!
    self.update(deleted: !self.deleted)
  end

  def fullname
    (family_name || NullObject.new) + (name || NullObject.new)
  end

  def role
    ROLE["#{self.role_id}"]
  end

  # Do not delete it unless you know what you are doning
  def email_required?
    false
  end
end
