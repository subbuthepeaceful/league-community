class AddSuperAdminUser < ActiveRecord::Migration
  def self.up
    super_admin_user = User.new
    super_admin_user.login = "admin"
    super_admin_user.name = "Super Admin User"
    super_admin_user.first_name = "Super Admin"
    super_admin_user.last_name = "User"
    super_admin_user.password = 'str0ngcircles'
    super_admin_user.password_confirmation = 'str0ngcircles'
    super_admin_user.email = 'subbu@coredotcontinuum.com'
    super_admin_user.site_admin = true
    super_admin_user.save!
  end

  def self.down
    super_admin_user = User.find_by_login("admin")
    if super_admin_user
      super_admin_user.destroy
    end
  end
end
