// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function() 
    { 
		$("#add_location").dialog({
			bgiframe: true,
			autoOpen: false,
			modal: true,
			width: 750,
			height: 600,
			title: "Add a Location",
			buttons: {
				'Add Location': function() {
					document.add_location_form.submit();
				},
				'Cancel': function() {
					$('#add_location').dialog('close');
				}
			}
		});
		$("#add_location_link").click(function() {
			$("#add_location").dialog('open');
		});
		$("#add_team").dialog({
			autoOpen: false,
			modal: true,
			width: 600,
			height: 300,
			title: "Add a Team",
			buttons: {
				'Add Team': function() {
					document.add_team_form.submit();
				},
				'Cancel': function() {
					$('#add_team').dialog('close');
				}
			}
		});
		$("#add_team_link").click(function() {
			$('#add_team').dialog('open');
		});
		$('.team-link').click(function() {
			var team_id = this.id.substr(5,1);
			var team_roster_div_id = "#team_table_" + team_id;
			$(team_roster_div_id).toggle("blind", null, "normal", null);

		});
		$('.expand-team').click(function() {
			var team_id = this.id.substr(5,1);
			var team_roster_div_id = "#team_table_" + team_id;
			$(team_roster_div_id).toggle("blind", null, "normal", null);
			if ($(this).hasClass('ui-icon-triangle-1-e')) {
				$(this).removeClass('ui-icon-triangle-1-e');
				$(this).addClass('ui-icon-triangle-1-s');
			} else {
				$(this).removeClass('ui-icon-triangle-1-s');
				$(this).addClass('ui-icon-triangle-1-e');
			}
		});
		$("#participants_table").tablesorter();
		$("#add_participant").dialog({
			bgiframe: true,
			autoOpen: false,
			modal: true,
			width: 850,
			height: 700,
			title: "Add a Participant",
			buttons: {
				'Add Participant': function() {
					document.add_participant_form.submit();
				},
				'Cancel': function() {
					$('#add_participant').dialog('close');
				}
			}
		});
		$("#add_participant_link").click(function() {
			$('#add_participant').dialog('open');
		});
		$("#participant_tabs").tabs();
		$("#participant_program").prepend("<option value='0' selected='selected'>Select Program</option>");
		$("#participant_birth_date").datepicker( {
			changeMonth: true,
			changeYear: true
		});
		$("#participant_program").click(
			function() {
				$.get("/admin/programs/" + this.value + "/sessions.xml", function(sessions) {
					$sessions = $(sessions);
					$('#participant_session').empty();
					$('#participant_division').empty();
					$('#participant_session').append("<option value='0' selected='selected'>Select Session</option>");
					$('#participant_division').append("<option value='0' selected='selected'>Select Division</option>");
					$sessions.find('session').each(
						function() {
							$('#participant_session').append(
								"<option value='" + $(this).find('id').text() + "'>" + $(this).find('name').text() + "</option>"
							);
						}
					);
				});
			}
		);
		$("#participant_session").click(
			function() {
				$program_id = $("#participant_program").val();
				$.get("/admin/programs/" + $program_id + "/sessions/" + this.value + "/divisions.xml", function(divisions) {
					$divisions = $(divisions);
					$('#participant_division').empty();
					$('#participant_division').append("<option value='0' selected='selected'>Select Division</option>");
					$divisions.find('division').each(
						function() {
							$('#participant_division').append(
								"<option value='" + $(this).find('id').text() + "'>" + $(this).find('name').text() + "</option>"
							);
						}
					);
				});
			}
		);
		$("#participant_registered_date").datepicker();
		$("#participant_same_address_across_contacts").click(
			function() {
				$("#participant_secondary_contact_street_address").val($("#participant_primary_contact_street_address").val());
				$("#participant_secondary_contact_city").val($("#participant_primary_contact_city").val());
				$("#participant_secondary_contact_state").val($("#participant_primary_contact_state").val());
				$("#participant_secondary_contact_zip").val($("#participant_primary_contact_zip").val());
			}
		);
		$("#registrants_table").tablesorter();
		$(".team-roster-action-link").click(function() {
			var $elem = $(this);
			var teamMemberName = $elem.parent().siblings('.registrant-name').text();
			// Need to get participant ID for tracking purposes
			var participantID = $elem.parent().parent().attr("id").substr(15);
			// Need to get current Team
			var teamTableCell = $elem.parent().siblings('.team-name');
			
			// Now to see if we're adding or removing
			if ($elem.text() == "ADD") {
				//alert("ADDING");
			
				var teamMemberList = $("#team_member_list").html();
				teamMemberList += "<li id='team_member_row_" + participantID + "'>" + teamMemberName + "</li>";
				$("#team_member_list").html(teamMemberList);
			
				var teamMemberRow = "#team_member_row_" + participantID;
			
				$(teamMemberRow).effect("highlight", null, "normal", null);
				
				$(teamTableCell).html("<span class='modified-table-cell'>Modified</span");
				
				$elem.text("REMOVE");
			}
			else {
				// alert("REMOVING");
				
				var teamMemberRow = "#team_member_row_" + participantID;
				$(teamMemberRow).remove();

				$(teamTableCell).html("<span class='modified-table-cell'>Modified</span");
				
				$elem.text("ADD");
			}
		});
		$(".roster-save").click(function() {
			var teamMemberList = $("#team_member_list");
			var teamMemberForm = $("#save_team_roster");
			
			var i = 0;
			var teamRosterIDs = "";
			$(teamMemberList).find('li').each(
				function() {
					if (i > 0) {
						teamRosterIDs += ","
					}
					teamRosterIDs += $(this).attr("id").substr(16);
					i += 1;
				});
			var teamRosterHiddenFieldHTML = "<input type='hidden' name='team_roster_list' value='" + teamRosterIDs + "' />"	
			$(teamMemberForm).append(teamRosterHiddenFieldHTML);
		});
		$("#assign_coaches").dialog({
			bgiframe: true,
			autoOpen: false,
			modal: true,
			width: 600,
			height: 500,
			title: "Assign Coaches",
			buttons: {
				'Assign Coaches': function() {
					$(this).find('form').submit();
				},
				'Cancel': function() {
					$(this).dialog('close');
				}
			}
		});
		$('.assign-coach-link').click(function() {
			var $elem = $(this);
			var teamName = $elem.parent().siblings().find('.team-link').text();
			var teamId = $(this).attr("id").substr(15);
			
			var teamIdHiddenFieldHTML = "<input type='hidden' name='team_id' value='" + teamId + "' />";
			
			$("#assign_coaches").find('h3').append("Assign Coaching Staff for " + teamName);
			$("#assign_coaches").find('form').append(teamIdHiddenFieldHTML);
			
			$("#assign_coaches").find('select').each(
				function() {
					var promptSelectOption = "<option value='' selected='selected'>Select Coach</option>";
					$(this).prepend(promptSelectOption);
				});
			$("#assign_coaches").dialog('open');
		});
		$("#create_division_schedule").dialog({
			bgiframe: true,
			autoOpen: false,
			modal: true,
			width: 850,
			height: 600,
			title: "Create Division Schedule",
			buttons: {
				'Create Schedule': function() {
					$(this).find('form').submit();
				},
				'Cancel': function() {
					$(this).dialog('close');
				}
			}
		});
		$("#create_division_schedule_link").click(function () {
			$("#create_division_schedule").dialog('open');
		});
		$(".game-time-slot-text").timeEntry({timeSteps: [1,15,0]});
		$(".add-time-slot").click(function() {
			var $daySlot = $(this).parent().parent().attr("id");
			var $dayForSlot = $daySlot.substr(11);
			
			var $gameSlotIndex = $(this).parent().parent().children().size();
			//alert($gameSlotIndex);
			
			var $newGameSlotIndex = $gameSlotIndex + 1;
			
			var appendGameSlotHTML = "<li id=" + $dayForSlot + "_game_" + $newGameSlotIndex + "\" class=\"game-slot game-" + $dayForSlot + "\">" +
									 "<label for=\"time_slot\">Time slot</label>" +
									 "<input class=\"game-time-slot-text\" id=\"" + $dayForSlot + "_slot_" + $newGameSlotIndex + "\" name=\"" 
									+ $dayForSlot + "_slot_" + $newGameSlotIndex + "\" size=\"10\" type=\"text\" value=\"\" />";
			
			$(this).parent().parent().append(appendGameSlotHTML);
			
			var $newGameSlotTime = "#" + $dayForSlot + "_slot_" + $newGameSlotIndex;
			$($newGameSlotTime).timeEntry({timeSteps: [1,15,0]}); 
									
		});
		$("#activate_division").dialog({
			bgiframe: true,
			autoOpen: false,
			modal: true,
			width: 800,
			height: 700,
			title: "Activate Division and Send Welcome Email",
			buttons: {
				'Activate': function() {
					$(this).find('form').submit();
				},
				'Cancel': function() {
					$('#activate_division').dialog('close');
				}
			}
		});
		$("#activate_division_online").click(function() {
			$('#welcome_email_subject').val("Welcome to the " + $divisionName + " for the " + $sessionName + " of " + $programName + " at the " + $hubName);
			$('#activate_division').dialog('open');
		});
		$("#import_participants").dialog({
			bgiframe: true,
			autoOpen: false,
			modal: true,
			width: 850,
			height: 770,
			title: "Import Participants",
			buttons: {
				'Cancel': function() {
					$('#import_participants').dialog('close');
				}
			}
		});
		$("#import_participants_link").click(function() {
			$('#loading_image').hide();
			$('#import_participants').dialog('open');
		});
		$("#file_upload_submit").click(function() {
			$('#loading_image').show();
		});
		$("#importable_participants_table").tablesorter();
		$("#processing_window").dialog({
			bgiframe: true,
			autoOpen: false,
			modal: true,
			width: 300,
			height: 100,
			title: "Processing",
			stack: true,
			zindex: 2000
		});
		$("#confirm_participant_import").dialog({
			bgiframe: true,
			autoOpen: true,
			modal: true,
			width: 900,
			height: 700,
			zindex: 1500,
			title: "Confirm Participant Import",
			buttons: {
				'Confirm Import': function() {
					$("#processing_window").dialog('open');	
					var $lastRow = $("#importable_participants_table").find('tr:last');
					$($lastRow).addClass("last");
					$("#importable_participants_table").find('tbody tr').each(function() {
						
						var $tableRow = $(this);
						var $participantHash = new Array();
						$participantHash['program'] = $(this).find('td#program').text();
						$participantHash['session'] = $(this).find('td#session').text();
						$participantHash['division'] = $(this).find('td#division').text();
						$participantHash['firstname'] = $(this).find('td#firstname').text();
						$participantHash['lastname'] = $(this).find('td#lastname').text();
						$participantHash['email'] = $(this).find('td#email').text();
						$participantHash['address'] = $(this).find('td#address').text();
						$participantHash['special_requests'] = $(this).find('td#special_requests').text();
					
						
						$.post("/admin/participants/confirm_import", {authenticity_token: window._token, 
																	  program: $participantHash['program'],
																	  session: $participantHash['session'],
																	  division: $participantHash['division'],
																	  firstname: $participantHash['firstname'],
																	  lastname: $participantHash['lastname'],
																	  email: $participantHash['email'],
																	  address: $participantHash['address'],
																	  special_requests: $participantHash['special_requests'] }, 
																	  function(data) {
							$tableRow.find('td#import_status').text("OK");
							if ($tableRow.hasClass("last")) {
								$("#confirm_participant_import").dialog('close');
								$("#processing_window").find(".processing-status").html("<a href=\"/admin/participants\" class=\"in-dialog-hyperlink\">Import Completed >></a>");
							}
						});
						
					});
				},
				'Cancel': function() {
					$("#confirm_participant_import").dialog('close');
				}
			}
		});
		$("#import_program").prepend("<option value='0' selected='selected'>Select Program</option>");
		$("#participant_birth_date").datepicker( {
			changeMonth: true,
			changeYear: true
		});
		$("#import_program").click(
			function() {
				$.get("/admin/programs/" + this.value + "/sessions.xml", function(sessions) {
					$sessions = $(sessions);
					$('#import_session').empty();
					$('#import_division').empty();
					$('#import_session').append("<option value='0' selected='selected'>Select Session</option>");
					$('#import_division').append("<option value='0' selected='selected'>Select Division</option>");
					$sessions.find('session').each(
						function() {
							$('#import_session').append(
								"<option value='" + $(this).find('id').text() + "'>" + $(this).find('name').text() + "</option>"
							);
						}
					);
				});
			}
		);
		$("#import_session").click(
			function() {
				$program_id = $("#import_program").val();
				$.get("/admin/programs/" + $program_id + "/sessions/" + this.value + "/divisions.xml", function(divisions) {
					$divisions = $(divisions);
					$('#import_division').empty();
					$('#import_division').append("<option value='0' selected='selected'>Select Division</option>");
					$divisions.find('division').each(
						function() {
							$('#import_division').append(
								"<option value='" + $(this).find('id').text() + "'>" + $(this).find('name').text() + "</option>"
							);
						}
					);
				});
			}
		);
		$(".process-link").click(function() {
			$("#processing_window").dialog('open');
		});
    } 
);



