class CalendarsController < ApplicationController
  def index
  end

  def show
    @user = User.find(params[:member_id])
    @desired_calendar_user = @user.calendars.select { |u| u.id == params[:id].to_i}[0]
    @calendar = @desired_calendar_user.calendar
  end

end