class PhotoProvider
  attr_accessor :name, :user_id, :album_id

  def initialize(params=nil)
    if params
      @name =  params[:name]
      @user_id = params[:user_id]
      @album_id = params[:album_id]
   end

  end

  def valid?
    !@name.blank? && !@user_id.blank?
  end


end