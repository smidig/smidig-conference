var smidig = smidig || {};
smidig.voter = (function($) {
  var talk_id, $form, $notice, $loader;

  function supports_html5_storage() {
    try {
      return 'localStorage' in window && window['localStorage'] !== null;
    } catch (e) {
      return false;
    }
  }

  function save_vote() {
    var votes = JSON.parse(localStorage.getItem("votes")) || {};
    votes[talk_id] = true;
    localStorage.setItem("votes", JSON.stringify(votes));
    finished();
  }

  function bind() {
    $form.submit(function() {
      var data = $form.serializeObject();
      $form.find("input[type=]").attr("disable", "disable");
      $form.hide();
      $loader.show();

      $.ajax({
          type: "POST",
          url: $(this).attr("action"),
          dataType: 'json',
          data: data,
          complete: function(xhr) {
            if (xhr.readyState == 4) {
              if (xhr.status == 201) {
                smidig.voter.save_vote();
              }
            } else {
              alert("Det skjedde noe galt ved lagring. Prøv igjen");
              $loader.hide();
              $form.show();
            }
          }
      });

      //cancel submit event..
      return false;
    });
  }

  function init() {
    $form = $("#new_feedback_vote");
    $notice = $("#feedback_vote_finished");
    $loader = $("#feedback_vote_loader");
    talk_id = $form.find("#feedback_talk_id").val();

    if(!supports_html5_storage()) {
      $notice.text("Din enhet støttes ikke");
      finished();
    }

    var votes = JSON.parse(localStorage.getItem("votes")) || {};
    if(votes[talk_id]) {
      finished();
    } else {
      bind();
    }
  }

  function finished() {
    $("#feedback_vote_loader").hide();
    $form.hide();
    $notice.show();
  }

  return {
    init: init,
    save_vote: save_vote
  };
})(jQuery);

$(function() {
  smidig.voter.init();
});





//Extensions
$.fn.serializeObject = function(){
  var o = {};
  var a = this.serializeArray();
  $.each(a, function() {
      if (o[this.name] !== undefined) {
          if (!o[this.name].push) {
              o[this.name] = [o[this.name]];
          }
          o[this.name].push(this.value || '');
      } else {
          o[this.name] = this.value || '';
      }
  });
  return o;
};