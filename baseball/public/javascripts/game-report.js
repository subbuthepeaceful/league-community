$(document).ready(function() {
	var $gameDate = new Date($game_scheduled_at_date);
	$("#game_report_actual_start_date").datepicker({ defaultDate: $gameDate});
	
	$("#game_report_actual_start_time").timeEntry({timeSteps: [1,15,0]});	
	$("#game_report_actual_end_time").timeEntry({timeSteps: [1,15,0]});	
});