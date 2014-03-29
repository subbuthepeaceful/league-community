$$.ready(function(){
  var gameInfo;
  var gameOpponent;
  var gameHA;
  var gameDate;

  var gameId;
  var gameSlotAssignUrl;

  $("#schedule_game_dialog").dialog({
    autoOpen: false,
    modal: true,
    width: 900,
    position: "top",
    resizable: true,
    buttons: [
      {
        text: "Update",
        click: function() { 
          gameSlotId = $("#fields_for_age_group").find(".slot_chosen").attr("id");
          gameSlotAssignUrl = "/game_slots/" + gameSlotId + "/assign_game";
          $.ajax({
            url: gameSlotAssignUrl,
            type: 'POST',
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            data: 'game_id=' + gameId,
            success: function(response) {
              $(this).dialog('close');
              location.reload(true);

            }
          });
          //$.post(gameSlotAssignUrl, { game_id: gameId });
        }
      },
      {
        text: "Cancel",
        click: function() { $(this).dialog('close');}
      }
    ]
  });

  $("#game_date_dialog").dialog({
    autoOpen: false,
    modal: true,
    width: 300,
    buttons: [
      {
        text: "Change",
        click: function() { 
          gameDate = $("#game_date_field").val(); 
          $("#game_date").text("Date : " + gameDate);

          $("span.field_game_day_uri").each(function(i) {
            var fieldGameDaySlotURL = $(this).text() + "?game_date=" + gameDate;
            $.get(fieldGameDaySlotURL, function(data){
              $("#field_" + i).html(data);
            }); 
          });
          var coachGameDayURL = $("span.coach_game_day_uri").first().text() + "?game_date=" + gameDate;
          $.get(coachGameDayURL, function(data) {
            $(".coach_schedule_table").each(function(i) {
              $(this).html(data);
            });
          });

          $(this).dialog('close');
        }
      },
      {
        text: "Cancel",
        click: function() { $(this).dialog('close');}
      }
    ]
  });

  $("#away_game_schedule_dialog").dialog({
    autoOpen: false,
    modal: true,
    width: 900,
    open: function(){ $(this).parent().css('overflow', 'visible'); $$.utils.forms.resize()},
    buttons: [
      {
        text: "Update",
        click: function() {
          gameUpdateUrl = "/games/" + gameId + "/update_away_details";
          $.ajax({
            url: gameUpdateUrl,
            type: 'POST',
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            data: { 
              away_game_date_time : gameDate.substring(0, 10) + " " + $("#away_game_date_time_field").val(), 
              away_game_location_field : $("#away_game_location_field").val(), 
              away_game_location_address_field : $("#away_game_location_address_field").val()
            },
            success: function(response) {
              $(this).dialog('close');
              location.reload(true);
            }
          });

        }
      },
      {
        text: "Cancel",
        click: function() { $(this).dialog('close');} 
      },
    ]
  });

  $(".schedule_away_dialog_btn").click(function() {
    gameInfo = $(this).parent().parent().first().html();
    gameOpponent = $(gameInfo).filter(".game_opponent").text();
    gameHA = $(gameInfo).filter(".game_h_or_a").text();
    gameDate = $(gameInfo).filter(".game_date").text();

    gameId = $(gameInfo).filter(".game_id").text();
    //alert(gameId);


    $("#away_game_title").text("Game : [" + gameHA.substring(0,4) + " Game] vs. " + gameOpponent);
    $("#away_game_date").text("Date : " + gameDate);

    $("#away_game_location_field").val("");
    $("#away_game_location_address_field").val("");

    var coachGameDayURL = $("span.coach_game_day_uri").first().text() + "?game_date=" + gameDate;
    $.get(coachGameDayURL, function(data) {
      $("#coach_schedule_table_away").html(data);
    });

    $("#away_game_schedule_dialog").dialog('open');

  })


  $(".schedule_home_dialog_btn").click(function() {

    gameInfo = $(this).parent().parent().first().html();
    gameOpponent = $(gameInfo).filter(".game_opponent").text();
    gameHA = $(gameInfo).filter(".game_h_or_a").text();
    gameDate = $(gameInfo).filter(".game_date").text();

    gameId = $(gameInfo).filter(".game_id").text();
    //alert(gameId);


    $("#game_title").text("Game : [" + gameHA.substr(0,4) + " Game] vs. " + gameOpponent);
    $("#game_date").text("Date : " + gameDate);

    $("span.field_game_day_uri").each(function(i) {
      var fieldGameDaySlotURL = $(this).text() + "?game_date=" + gameDate;
      $.get(fieldGameDaySlotURL, function(data){
        $("#field_" + i).html(data);
      }); 
    });

    var coachGameDayURL = $("span.coach_game_day_uri").first().text() + "?game_date=" + gameDate;
    $.get(coachGameDayURL, function(data) {
      $("#coach_schedule_table_home").html(data);
    });

    $("#schedule_game_dialog").dialog('open');

  });

  $("a.change_date").click(function() {
    $("#game_date_field").val(gameDate);
    $("#game_date_dialog").dialog('open');
  });

  $("#add_game_dialog").dialog({
    autoOpen: false,
    modal: true,
    width: 600,
    open: function(){ $(this).parent().css('overflow', 'visible'); $$.utils.forms.resize()},
    buttons: [
      {
        text: "Add",
        click: function() {
          gameAddUrl = "/teams/" + currentTeamId + "/games";
          $.ajax({
            url: gameAddUrl,
            type: 'POST',
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            data: { 
              new_game_opponent: $("#new_game_opponent").val(),
              new_game_date: $("#new_game_date").val(),
              new_game_home: $("#new_game_home").attr("checked"),
              new_game_comments: $("#new_game_comments").val()
            },
            success: function(response) {
              $(this).dialog('close');
              location.reload(true);
            }
          });
        }
      },
      {
        text: "Cancel",
        click: function() { $(this).dialog('close');} 
      },
    ]
  });

  $("a.add_game_btn").click(function(){
    $("#add_game_dialog").dialog("open");
  });

  $("#toggle_home_away_dialog").dialog({
    autoOpen: false,
    modal: true,
    width: 400,
    buttons: [
      {
        text: "Confirm",
        click: function() {
          gameUpdateUrl = "/games/" + gameId + "/switch_home_away";
          $.ajax({
            url: gameUpdateUrl,
            type: 'POST',
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            data: { 
              game_id: gameId
            },
            success: function(response) {
              $(this).dialog('close');
              location.reload(true);
            }
          });
        }
      },
      {
        text: "Cancel",
        click: function() { $(this).dialog('close');}
      }
    ]
  });

  $("a.toggle_home_away").click(function(){
    gameInfo = $(this).parent().parent().first().html();
    gameId = $(gameInfo).filter(".game_id").text();
    //alert(gameId);

    $("#toggle_home_away_dialog").dialog("open");

  })


});
