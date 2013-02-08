// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var $participantId;

$(document).ready(function() {
		$(".user-form-submit").mouseover(function(){
			$(this).addClass("user-form-submit-hover");
		});
		$(".user-form-submit").mouseout(function() {
			$(this).removeClass("user-form-submit-hover");
		});
		$("a.openclose").click(function(){
			var $elem = $(this);
			var $ltcolBox = $elem.parent().parent().parent().children(".ltcolbox-bod");
			$ltcolBox.slideToggle("slow");
		});
		$("#weekly_calendar").fullCalendar({
			year: 2012,
			month: 2,
			defaultView: 'basicWeek',
			aspectRatio: 4,
			header: {
				left: 'prev today',
				center: 'title',
				right: 'next'
			},
			buttonText: {
				prev: '&laquo;',
				next: '&raquo;'
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
		$("#new_message").dialog({
			bgiframe: true,
			autoOpen: false,
			modal: true,
			width: 750,
			height: 650,
			title: "StrongCircles : My Messages",
			buttons: {
				'Send Message': function() {
					document.new_message_form.submit();
				},
				'Cancel': function() {
					$('#new_message').dialog('close');
				}
			}
		});
		$(".sendmsg").click(function(){
			$("#new_message").dialog('open');
		});
		$("a.readmsg").click(function(){
			var $elem = $(this);
			var $msgBody = $elem.parent().children(".message-body");
			if ($elem.text() == "read") {
				$elem.text("close");
				$msgItem = $elem.parent().children(".msgsubject");
				$($msgItem).removeClass("unread");
				
				// Need to do an AJAX POST to mark message as read
				var $msgId = $($msgItem).attr("id").substr(8);
				var $msgReadAction = "/participants/" + $participantId + "/messages/" + $msgId + "/read.js";
				$.post($msgReadAction);
			}
			else {
				$elem.text("read");
			}
			$msgBody.slideToggle("slow");
		});
		$("#reply_message").dialog({
			bgiframe: true,
			autoOpen: false,
			modal: true,
			width: 750,
			height: 650,
			title: "StrongCircles : My Messages",
			buttons: {
				'Send Reply': function() {
					$("#reply_message_form").submit();
				},
				'Cancel': function() {
					$('#reply_message').dialog('close');
				}
			}
		});
		$("a.replymsg").click(function() {
			var $msgId = $(this).attr("id").substr(6);
			var $msgSubjectElem = "#subject_" + $msgId;
			var $msgSubject = $($msgSubjectElem).text();
			var $msgBodyElem = "#body_" + $msgId + " p";
			var $msgBody = $($msgBodyElem).text();
			
			$("#message_subject").val($msgSubject);
			$("#message_body").val($msgBody);

			$msgReplyAction =  "/participants/" + $participantId + "/messages/"+ $msgId + "/reply";
			$("#reply_message_form").attr("action", $msgReplyAction);

			$("#reply_message").dialog('open');
			//alert($("#reply_message_form").attr("action"));
			
		});
		$("#participant_event_details").dialog({
			bgiframe: true,
			autoOpen: false,
			modal: true,
			width: 750,
			height: 650,
			title: "StrongCircles: Scheduled Event Details",
			buttons: {
				'Close': function() {
					$('#participant_event_details').dialog('close');
				}
			}
		});
		$("#set_team_name").dialog({
			bgiframe: true,
			autoOpen: false,
			modal: true,
			width: 500,
			height: 300,
			title: "StrongCircles: Enter a Team Name",
			buttons: {
				'Set Name': function() {
					document.set_team_name_form.submit();
				},
				'Cancel': function() {
					$('#set_team_name').dialog('close');
				}
			}
		});
		$(".teamname").click(function() {
			$("#set_team_name").dialog('open');
		});
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
    $("#upload_picture_submit").click(function() {
      $("#processing_window").dialog('open');
    });
		$("#preview_albums_submit").click(function() {
			$("#processing_window").dialog('open');
		});
		$("#preview_album_photos_submit").click(function() {
			$("#processing_window").dialog('open');
		});
		$("#set_participant_photo").dialog({
			bgiframe: true,
			autoOpen: false,
			modal: true,
			width: 700,
			height: 300,
			title: "StrongCircles: Update Profile Photo",
			buttons: {
				'Set Photo': function() {
					$("#processing_window").dialog('open');
					document.profile_photo_form.submit();
				},
				'Cancel': function() {
					$("#set_participant_photo").dialog('close');
				}
			}
		});
		$("a.set-profile-photo").click(function() {
			$("#set_participant_photo").dialog('open');
		});	
		$("#set_contact_photo").dialog({
			bgiframe: true,
			autoOpen: false,
			modal: true,
			width: 700,
			height: 300,
			title: "StrongCircles: Update Profile Photo",
			buttons: {
				'Set Photo': function() {
					$("#processing_window").dialog('open');
					document.contact_profile_photo_form.submit();
				},
				'Cancel': function() {
					$("#set_contact_photo").dialog('close');
				}
			}
		});
		$("a.set-contact-photo").click(function() {
			$("#set_contact_photo").dialog('open');
		});	
		$("#set_team_logo").dialog({
			bgiframe: true,
			autoOpen: false,
			modal: true,
			width: 700,
			height: 300,
			title: "StrongCircles: Update Team Logo",
			buttons: {
				'Set Photo': function() {
					$("#processing_window").dialog('open');
					document.team_logo_form.submit();
				},
				'Cancel': function() {
					$("#set_team_logo").dialog('close');
				}
			}
		});
		$("a.set-team-logo").click(function() {
			$("#set_team_logo").dialog('open');
		});	
		
    $("#photo_dialog").dialog({
      bgiframe: true,
      autoOpen: false,
      modal: true,
      width: 700,
      height: 550,
      title: "Picture",
      buttons: {
        'Cancel': function() {
          $('#photo_dialog').dialog('close');
        }
      }
    });

	$("#participant_id").change(function() {
		selectedValue = $(this).val();
		dashboard_url = "/participants/" + selectedValue + "/dashboard"
		window.location = dashboard_url
	});

    $('input[name=select_all_pictures]').click(function() {
      var val = $('input[name=select_all_pictures]').is(':checked')
      $("input[name='pictures[]']").each(
        function(i, selected) {
          $(selected).attr("checked",val);
        }
      );
    });

	$("#set_jersey_number").dialog({
		bgiframe: true,
		autoOpen: false,
		modal: true,
		width: 700,
		height: 600,
		title: "Set Jersey Numbers for Team",
		buttons: {
			'Set Jersey Numbers': function() {
				document.set_jersey_number_form.submit();
			},
			'Cancel': function() {
				$('#set_jersey_number').dialog('close');
			}
		}
	});
	$("a.jersey-number").click(function(){
		$("#set_jersey_number").dialog('open');
	});
	$("#division_select").change(function() {
		selectedValue = $(this).val();
		divisionUrl = "/hubs/" + $hubId + "/view?division_id=" + selectedValue;
		window.location = divisionUrl;
	});
	$("#star_player_votes").tablesorter();
	
	$("#edit_names_jerseys").dialog({
		bgiframe: true,
		autoOpen: false,
		modal: true,
		width: 700,
		height: 600,
		title: "Update Players : Names and Jersey #s",
		buttons: {
			'Update': function() {
				document.edit_names_jerseys_form.submit();
			},
			'Cancel': function() {
				$("#edit_names_jerseys").dialog('close');
			}
		}
	});
	$("a.edit-roster").click(function() {
		$('#edit_names_jerseys').dialog('open');
	});
  }
);

function showPhotoDialog(photo_link, caption){
  $('#photo_dialog_photo').html(photo_link);
  $('#photo_dialog_caption').html(caption);
  $('#photo_dialog').dialog('open');
  return false;
}

