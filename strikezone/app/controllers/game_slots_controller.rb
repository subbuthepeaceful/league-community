class GameSlotsController < ApplicationController
  def index
    @field = Field.find(params[:field_id])
    @game_slots = @field.game_slots_for_date(params[:game_date].to_date)
    respond_to do |format|
      format.html { render :partial => "by_date"}
      format.json { render :json => @game_slots }
    end
  end

  def assign_game
    @game = Game.find(params[:game_id])
    @game_slot = GameSlot.find(params[:id])

    @game.game_slot = @game_slot
    @game.game_date = @game_slot.game_date_time.to_date
    @game.game_time = @game_slot.game_date_time
    @game.save!


    respond_to do |format|
      format.html { render :text => "OK"}
      format.js { render :text => "OK"}
    end
  end
end