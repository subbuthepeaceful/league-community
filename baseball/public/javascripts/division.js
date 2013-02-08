var $divisionId;
var $divisionStartYear;
var $divisionStartMonth;

$(document).ready(function() 
    { 
		$("#add_division").dialog({
			autoOpen: false,
			modal: true,
			width: 600,
			height: 600,
			title: "Add a Division",
			buttons: {
				'Add Division': function() {
					document.add_division_form.submit();
				},
				'Cancel': function() {
					$('#add_division').dialog('close');
				}
			}
		});
		$("#add_division_link").click(function() {
			$('#add_division').dialog('open');
		});
		$("#game_details").dialog({
			bgiframe: true,
			autoOpen: false,
			modal: true,
			width: 600,
			height: 500,
			title: "Game Details",
			buttons: {
				'Update': function() {
					$(this).find('form').submit();
				},
				'Cancel': function() {
					$(this).dialog('close');
				}
			}
		});
		$("#division_calendar").fullCalendar({
			year: $divisionStartYear,
			month: $divisionStartMonth,
			theme: true,
			header: {
					left: 'prev,next today',
					center: 'title',
					right: 'month,basicWeek,basicDay'
				},
			events: "/admin/divisions/" + $divisionId + "/schedule.json",
			eventClick: function(calEvent, jsEvent, view) {
				var $gameId = calEvent.id;
				var $gameMonth = calEvent.start.getMonth() + 1;
				var $gameDate = calEvent.start.getDate();
				var $gameYear = calEvent.start.getFullYear();
				var $gameDateStr = $gameMonth + "/" + $gameDate + "/" + $gameYear;
				$("#game_details").find('h3').text("Game : " + $gameId);
				$("#game_details").find(".game-date-text").datepicker({defaultDate: calEvent.start, showOn: 'button'});
				$("#game_details").find(".game-date-text").val($gameDateStr);
		
				$("#game_details").find(".game-time-text").timeEntry({timeSteps: [1,15,0]});
				$("#game_details").find(".game-time-text").timeEntry('setTime', calEvent.start);
		
				$('#game_details').find('form').attr("action", "/admin/divisions/" + $divisionId + "/games/" + $gameId + "/update");
		
				$("#game_details").dialog('open');
			},
		});
		$("#add_division_event").dialog({
			autoOpen: false,
			modal: true,
			width: 700,
			height: 600,
			title: "Add an Event to the Division Calendar",
			buttons: {
				'Add Event': function() {
					document.add_division_event_form.submit();
				},
				'Cancel': function() {
					$("#add_division_event").dialog('close');
				}
			}
		});
		$("#event_start_date").datepicker();
		$("#event_start_time").timeEntry({timeSteps: [1,15,0]});
		$("#event_end_date").datepicker();
		$("#event_end_time").timeEntry({timeSteps: [1,15,0]});
		$("#event_location").prepend("<option value='0' selected='selected'>Select Location</option>");
		$("#add_division_event_link").click(function() {
			$("#add_division_event").dialog('open');
		});
		
	}
);