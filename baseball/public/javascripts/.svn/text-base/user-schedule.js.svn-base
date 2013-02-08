$(document).ready(function() 
    { 
		$("#participant_schedule").fullCalendar({
			year: 2012,
			month: 3,
			theme: true,
			header: {
				left: 'prev,next, today',
				center: 'title',
				right: 'month,basicWeek,basicDay'
			},
			events: "/participants/" + $participantId + "/schedule.json", 
			eventClick: function(calEvent, jsEvent, view) {
				var $eventId = calEvent.id;
				var $eventType = calEvent.eventType;
				// alert($eventId);
				$("#event_detail").load("/participants/" + $participantId + "/events/" + $eventId + "?event_type=" + $eventType);
				$("#participant_event_details").dialog('open');
			}
		});
		$("#team_schedule").fullCalendar({
			year: 2012,
			month: 3,
			theme: true,
			header: {
				left: 'prev,next, today',
				center: 'title',
				right: 'month,basicWeek,basicDay'
			},
			events: "/teams/" + $teamId + "/schedule.json" 
			//eventClick: function(calEvent, jsEvent, view) {
				//var $eventId = calEvent.id;
				//var $eventType = calEvent.eventType;
				// alert($eventId);
				//$("#event_detail").load("/participants/" + $participantId + "/events/" + $eventId + "?event_type=" + $eventType);
				//$("#participant_event_details").dialog('open');
			//}
		});
		$("#division_schedule").fullCalendar({
			year: 2010,
			theme: true,
			header: {
				left: 'prev,next, today',
				center: 'title',
				right: 'month,basicWeek,basicDay'
			},
			events: "/divisions/" + $divisionId + "/schedule.json" 
			//eventClick: function(calEvent, jsEvent, view) {
				//var $eventId = calEvent.id;
				//var $eventType = calEvent.eventType;
				// alert($eventId);
				//$("#event_detail").load("/participants/" + $participantId + "/events/" + $eventId + "?event_type=" + $eventType);
				//$("#participant_event_details").dialog('open');
			//}
		});
		$("#game_details").dialog({
			bgiframe: true,
			autoOpen: false,
			modal: true,
			width: 600,
			height: 500,
			title: "Game Details",
			buttons: {
				'Add Game': function() {
					$(this).find('form').submit();
				},
				'Cancel': function() {
					$(this).dialog('close');
				}
			}
		});
		$("#add_game").click(function() {
			$("#game_details").dialog('open');
		});
	}
);
