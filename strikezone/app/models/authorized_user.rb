class AuthorizedUser < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :email

  has_and_belongs_to_many :teams

  def to_s
    "#{first_name} #{last_name} (#{email})"
  end

  def name
    "#{first_name} #{last_name}"
  end


end