$(document).ready(function() 
    {
	    $("#programs_table").tablesorter({
			headers: {
				4: {
					sorter: false
				}
			}
		});
		$("#program_schedule").fullCalendar({
			year: 2010,
			month: 0,
			theme: true,
			header: {
				left: 'prev,next, today',
				center: 'title',
				right: 'month,basicWeek,basicDay'
			},
			events: "/admin/programs/schedules.json" 
		});
		$("#add_program").dialog({
			bgiframe: true,
			autoOpen: false,
			modal: true,
			width: 600,
			height: 500,
			title: "Add a Program",
			buttons: {
				'Add Program': function() {
					document.add_program_form.submit();
				},
				'Cancel': function() {
					$('#add_program').dialog('close');
				}
			}
		});
		$("#add_program_link").click(function() {
			$('#add_program').dialog('open');
		});
     
	}
);