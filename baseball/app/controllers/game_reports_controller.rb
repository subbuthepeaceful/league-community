class GameReportsController < ApplicationController
  before_filter :login_required, :set_contact, :except => [:public]
  def index
  end
  
  def show
    @nav = "coaching"
    @game_report = GameReport.find(params[:id])
    @team = @game_report.team
    @game = @game_report.game
    
    @game_statistics = @game_report.decompose_statistics
    determine_head_coach
  end
  
  def new
    @nav = "coaching"
    @team = Team.find(params[:team_id])
    @game = Game.find(params[:game_id])
    
    determine_head_coach
    unless @game_report.nil?
      @game_report = GameReport.new
    end
  end
  
  def create
    @nav = "coaching"
    @team = Team.find(params[:team_id])
    @game = Game.find(params[:game_id])
    
    determine_head_coach
    
    @game_report = GameReport.create_from_params(@team, @game, @contact, params[:game_report])
    if @game_report.valid? || !pre_save_validation_checks(params, @game_report)
      begin
        @game_report.state = "Saved"
        @game_report.save!
        unless @game.is_interlock?
          @game_report.save_star_player_votes params[:game_report]
        end
        @game_report.save_statistics params
        redirect_to team_game_game_report_path(@team, @game, @game_report)
      rescue
        render :action => "new"
      end
    else
      render :action => "new"
    end
  end
  
  def destroy
    @game_report = GameReport.find(params[:id])
    @team = @game_report.team
    @game = @game_report.game
    
    @game_report.clear_statistics
    @game_report.clear_star_player_votes
    @game_report.delete
    
    redirect_to new_team_game_game_report_path(@team, @game)
  end
  
  def view
    @nav = "admin"
    @game_report = GameReport.find(params[:id])
    @team = @game_report.team
    @game = @game_report.game
    
    @game_statistics = @game_report.decompose_statistics
  end
  
  def confirm
    @game_report = GameReport.find(params[:id])
    @game_report.state = "Confirmed"
    @game_report.save!
    
    @game_report.process_notifications
    redirect_to gamelist_team_path(@game_report.team)
  end

  def plain
    @nav = "division"
    @game_report = GameReport.find(params[:id])
    @team = @game_report.team
    @game = @game_report.game
    
    @game_statistics = @game_report.decompose_statistics
  end
  
  def public
    @game_report = GameReport.find(params[:id])
    @team = @game_report.team
    @game = @game_report.game
    
    @game_statistics = @game_report.decompose_statistics
    
    render :template => "game_reports/public", :layout => "iframe"
  end
  
  def edit
    @nav = "coaching"
    @game_report = GameReport.find(params[:id])
    @team = @game_report.team
    @game = @game_report.game
    
    determine_head_coach
    
    @game_statistics = @game_report.decompose_statistics
    # Need to develop a player array to support the editable form
    @team_stats_by_player = Hash.new
    @team.players.each_with_index do |p,i|
      @game_statistics.each do |gs|
        if gs[:player] == p
          # We have a statistic for this player
          
          if gs[:pitcher_number]  
            key1 = "pitcher_#{i}".to_sym
            key2 = "innings_#{i}".to_sym
            key3 = "pitches_#{i}".to_sym
            @team_stats_by_player[key1] = gs[:pitcher_number]
            @team_stats_by_player[key2] = gs[:innings_pitched]
            @team_stats_by_player[key3] = gs[:pitch_count]
          elsif gs[:innings_caught]
            key4 = "catches_#{i}".to_sym
            @team_stats_by_player[key4] = gs[:innings_caught]
          end
        end
      end # Loop through Game Statistics
    end # Loop through players
  end
  
  def update
    @nav = "coaching"
    @game_report = GameReport.find(params[:id])
    @team = @game_report.team
    @game = @game_report.game
    @game_statistics = @game_report.decompose_statistics
    
    determine_head_coach
    
    # Need to develop a player array to support the editable form
    @team_stats_by_player = Hash.new
    @team.players.each_with_index do |p,i|
      @game_statistics.each do |gs|
        if gs[:player] == p
          # We have a statistic for this player
          
          if gs[:pitcher_number]  
            key1 = "pitcher_#{i}".to_sym
            key2 = "innings_#{i}".to_sym
            key3 = "pitches_#{i}".to_sym
            @team_stats_by_player[key1] = gs[:pitcher_number]
            @team_stats_by_player[key2] = gs[:innings_pitched]
            @team_stats_by_player[key3] = gs[:pitch_count]
          elsif gs[:innings_caught]
            key4 = "catches_#{i}".to_sym
            @team_stats_by_player[key4] = gs[:innings_caught]
          end
        end
      end # Loop through Game Statistics
    end # Loop through players
    
    @game_report.update_from_params(@team, @game, @contact, params[:game_report])
    if @game_report.valid? || !pre_save_validation_checks(params, @game_report)
      begin
        @game_report.state = "Saved"
        @game_report.save!
        
        # Clear old votes
        @game_report.clear_statistics
        unless @game.is_interlock?
          @game_report.clear_star_player_votes
          @game_report.save_star_player_votes params[:game_report]
        end
        @game_report.save_statistics params
        redirect_to team_game_game_report_path(@team, @game, @game_report)
      rescue
        render :action => "edit"
      end
    else
      render :action => "edit"
    end
  end
  
  protected
  def determine_head_coach
    if @team.head_coach == @contact
      @is_head_coach = true
    else
      @is_head_coach = false
    end
    # Determine assistant coach
    if @team.assistant_coaches.include?(@contact)
      @is_assistant_coach = true
    else
      @is_assistant_coach = false
    end
    
  end
  
  def uniqueness_of_all_star_votes(params, game_report)
    if (params[:first_vote] == params[:second_vote]) ||
       (params[:first_vote] == params[:third_vote]) ||
       (params[:second_vote] == params[:third_vote])
       game_report.errors.add_to_base "Please review your all-star selections for blanks or duplicates"
     end
   end
  
  def at_least_one_pitcher(params, game_report)
    game_report.team.players.each_with_index do |p,i|
      #Pitching Statistics
      @at_least_one_pitcher = false
      key1 = "pitcher_#{i}".to_sym
      if !params[key1].blank?
        # We have an entry for this player
        return
      end
    end
    unless @at_least_one_pitcher
      game_report.errors.add_to_base "Please enter data for at least one pitcher"
    end
  end    
  
  def stats_for_pitching(params, game_report)
    game_report.team.players.each_with_index do |p,i|
      #Pitching Statistics
      key1 = "pitcher_#{i}".to_sym
      key2 = "innings_#{i}".to_sym
      key3 = "pitches_#{i}".to_sym
      unless params[key1].blank?
        # We have an entry for this player
        if params[key2].blank? || params[key3].blank?
          game_report.errors.add_to_base "Player #{p.name} has been entered as a pitcher but no counts provided"
        end
      end
    end
  end
  
  def pre_save_validation_checks(params, game_report)
    #uniqueness_of_all_star_votes(params[:game_report], game_report)
    at_least_one_pitcher(params, game_report)
    stats_for_pitching(params, game_report)
    if game_report.errors.size > 0
      return true
    else
      return false
    end
  end
  
end