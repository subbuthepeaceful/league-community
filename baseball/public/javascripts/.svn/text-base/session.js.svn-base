$(document).ready(function() 
    { 
		$("#add_session").dialog({
			autoOpen: false,
			modal: true,
			width: 600,
			height: 500,
			title: "Add a Session",
			buttons: {
				'Add Session': function() {
					document.add_session_form.submit();
				},
				'Cancel': function() {
					$('#add_session').dialog('close');
				}
			}
		});
		$("#session_schedule").fullCalendar({
			year: 2010,
			month: 0,
			theme: true,
			header: {
				left: 'prev,next, today',
				center: 'title',
				right: 'month,basicWeek,basicDay'
			},
			events: "/admin/programs/" + $programId + "/sessions/schedules.json" 
		});
		$("#add_session_link").click(function() {
			$('#add_session').dialog('open');
		});
		$("#session_start_date").datepicker();
		$("#session_end_date").datepicker();
		$("#add_session_event").dialog({
			autoOpen: false,
			modal: true,
			width: 700,
			height: 600,
			title: "Add an Event to the Session Calendar",
			buttons: {
				'Add Event': function() {
					document.add_session_event_form.submit();
				},
				'Cancel': function() {
					$("#add_session_event").dialog('close');
				}
			}
		});
		$("#event_start_date").datepicker();
		$("#event_start_time").timeEntry({timeSteps: [1,15,0]});
		$("#event_end_date").datepicker();
		$("#event_end_time").timeEntry({timeSteps: [1,15,0]});
		$("#event_location").prepend("<option value='0' selected='selected'>Select Location</option>");
		$("#add_session_event_link").click(function() {
			$("#add_session_event").dialog('open');
		});
		$("#session_schedule_with_events").fullCalendar({
			year: 2010,
			month: 0,
			theme: true,
			header: {
				left: 'prev,next, today',
				center: 'title',
				right: 'month,basicWeek,basicDay'
			},
			events: "/admin/programs/" + $programId + "/sessions/" + $sessionId + "/schedule.json"
		});
	}
);