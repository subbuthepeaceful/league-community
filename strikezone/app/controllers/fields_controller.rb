class FieldsController < ApplicationController

  def index
  end

  def show
    @field = Field.find(params[:id])
    @calendar = @field.calendar
  end

  def on_date
    @age_group = AgeGroup.find(params[:age_group_id])
    @fields = @age_group.fields

    @game_date_parts = params[:game_date].match(/(.*)\/(..)\/(\d\d\d\d)/)
    @game_date = "#{@game_date_parts[3]}-#{@game_date_parts[1]}-#{@game_date_parts[2]}"


    render :template => "fields/on_date", :layout => false
  end

  def for_date
    @field = Field.find(params[:id])
    @game_date_parts = params[:game_date].match(/(.*)\/(..)\/(\d\d\d\d)/)
    @game_date = "#{@game_date_parts[3]}-#{@game_date_parts[1]}-#{@game_date_parts[2]}"

    @game_slots = @field.game_slots_for_date(@game_date)

    render :template => "fields/for_date", :layout => false
  end
end