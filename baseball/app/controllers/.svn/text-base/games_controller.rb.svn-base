class GamesController < ApplicationController
  before_filter :login_required, :set_contact
  
  def index
  end
  
  def show
    @game = Game.find(params[:id])
  end
end  
