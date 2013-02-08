class AdminRole < ActiveRecord::Base
  belongs_to :contact
  
  def resolve
    resolution = Hash.new
    if self.admin_classification == "Division"
      # This is a Division Director
      resolution[:division] = self.admin_classification
      resolution[:id] = self.admin_instance
      resolution[:title] = construct_admin_title
      resolution[:url] = construct_admin_role_url
    elsif self.admin_classification == "Hub"
      # This is a League Executive
      resolution[:hub] = self.admin_classification
      resolution[:id] = self.admin_instance
      resolution[:title] = construct_admin_title
      resolution[:url] = construct_admin_role_url
    end
    resolution
  end
  
  protected
  def construct_admin_title
    title = ''
    if self.admin_classification == "Division"
      @instance = Division.find(self.admin_instance)
      title = "#{@instance.name} #{self.role_title}"
    elsif self.admin_classification == "Hub"
      title = "#{self.role_title}"
    end
    title
  end
  
  def construct_admin_role_url
    url = ''
    if self.admin_classification == "Division"
      @instance = Division.find(self.admin_instance)
      url = "/divisions/#{@instance.id}/admin_roles"
    elsif self.admin_classification == "Hub"
      @instance = Hub.find(self.admin_instance)
      url = "/hubs/#{@instance.id}/admin_roles"
    end
    url
  end
end