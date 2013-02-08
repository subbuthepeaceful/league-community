class PicturesController < ApplicationController
  before_filter :login_required, :set_participant

  def index
    @my_photos = Photo.paticipant_photos(@participant)
    @team_photos = Photo.team_other_photos(@participant.team, @participant)
  end


  def new
    @provider = PhotoProvider.new
  end

  def create
    unless params[:photo][:image]
      render :action => :new
      return false
    end

    begin
      Photo.create(:user_id => current_user.id,
                   :participant_id => @participant.id,
                   :team_id => @participant.team.id,
                   :title => params[:photo][:title],
                   :image => params[:photo][:image],
                   :publish_date => Time.now)
    rescue => ex
      flash[:error] = "There was a problem saving the uploaded picture. Please try again."
      logger.error "Error occured while saving uploaded photos for participant #{@participant.id}: #{ex.message}"
      logger.error ex.backtrace.join("\n");
      render :action => :new
      return false
    end

    redirect_to participant_pictures_path(@participant)
  end

  def preview
    @provider = PhotoProvider.new(params[:provider])
    unless @provider.valid?
      render :action => :new
      return false
    end

    if @provider.name == PHOTO_PROVIDER_PICASA
      @provider.user_id = sanitize_picasa_user_id(@provider.user_id)
    end

    unless params[:provider].has_key?('album_id')
      @album_feeds = get_albums(@provider)

      if @provider.name == PHOTO_PROVIDER_PICASA || !@album_feeds.empty?
        render :action => :new and return false
      end
    end

    begin
      get_photos(@provider)
    rescue => ex
      flash[:error] = " Error occurred while retriving pictures from the specified provider. Please check your user ID and try again"
      render :action => :new
      return false
    end

    @shared_photos = Photo.paticipant_photos(@participant, @provider).collect{|p| p.source_photo_id}
  end

  def share
    @provider = PhotoProvider.new(params[:provider])
    @provider.user_id = sanitize_picasa_user_id(@provider.user_id)
    @shared_photos = params[:pictures]

    if @shared_photos && !@shared_photos.empty?
      begin
        get_photos(@provider)
      rescue => ex
        flash[:error] = " Error occurred while retriving pictures from the specified provider. Please check your user ID and try again"
        render :action => :new
        return false
      end

      current_photos = Photo.paticipant_photos(@participant, @provider).collect{|p| p.source_photo_id}
      new_photos = @shared_photos.select{|p| !current_photos.include?(p)}
      begin
        Photo.transaction do
          new_photos.each do |p|
            match = @feeds.select{|f| f.photo_id == p}
            unless match.empty?
              Photo.create_participant_photo(current_user, @participant, @provider, match[0])
            end
          end
        end
      rescue => ex
        flash[:error] = "There was a problem saving the shared photos. Please try again."
        logger.error "Error occured while saving shared photos for participant #{@participant.id}: #{ex.message}"
        logger.error ex.backtrace.join("\n");
        render :action => :preview
        return false
      end
    end

    redirect_to participant_pictures_path(@participant)
  end

  def destroy
    Photo.delete_participant_photo(current_user, @participant, params[:id])
    redirect_to participant_pictures_path(@participant)
  end

  private
  def get_albums(provider)
    case @provider.name
    when PHOTO_PROVIDER_FLICKR
      @album_feeds = FlickrService.get_albums(@provider.user_id)
    when PHOTO_PROVIDER_PICASA
      @album_feeds = PicasaService.get_albums(@provider.user_id)
    end
  end

  def get_photos(provider)
    case @provider.name
    when PHOTO_PROVIDER_FLICKR
      @feeds = FlickrService.get_photos(@provider.user_id, @provider.album_id)
    when PHOTO_PROVIDER_PICASA
      @feeds = PicasaService.get_photos(@provider.user_id, @provider.album_id)
    end
  end

  def sanitize_picasa_user_id(user_id)
    user_id.blank? ? user_id : user_id.gsub(/@gmail.com\s*$/i,'')
  end
end