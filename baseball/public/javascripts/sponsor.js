$(document).ready(function()
    {
	    $("#sponsors_table").tablesorter({
			headers: {
				4: {
					sorter: false
				}
			}
		});
		$("#add_sponsor").dialog({
			bgiframe: true,
			autoOpen: false,
			modal: true,
			width: 700,
			height: 550,
			title: "Add a Sponsor",
			buttons: {
				'Add Sponsor': function() {
					document.add_sponsor_form.submit();
				},
				'Cancel': function() {
					$('#add_sponsor').dialog('close');
				}
			}
		});
		$("#add_sponsor_link").click(function() {
			$('#add_sponsor').dialog('open');
		});

	}
);