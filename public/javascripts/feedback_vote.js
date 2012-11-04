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

  function save_vote($form, talk_id) {
    var votes = JSON.parse(localStorage.getItem("votes")) || {};
    votes[talk_id] = true;
    localStorage.setItem("votes", JSON.stringify(votes));
    finished($form);
  }

  function bind($form, talk_id) {
    $form.find("input[name='commit']").click(function() {
      var data = $form.serializeObject();
      if(!data["feedback_vote[vote]"]) {
        alert("Du må gi minst 1 stjerne!");
        return;  
      }
      
      $form.find(".inputs").hide();
      $form.find(".ajaxloader").show();
      $form.find(".ajaxloader").css("visibility", "visible")

      $.ajax({
          type: "POST",
          url: $form.attr("action"),
          dataType: 'json',
          data: data,
          complete: function(xhr) {
            if (xhr.readyState == 4) {
              if (xhr.status == 201) {
                smidig.voter.save_vote($form, talk_id);
              }
            } else {
              alert("Det skjedde noe galt ved lagring. Prøv igjen");
              $form.find(".ajaxloader").hide();
              $form.find(".inputs").show();
            }
          }
      });

      //cancel submit event..
      return false;
    });
  }

  function init($form, talk_id) {
    if(!supports_html5_storage()) {
      $notice.text("Din enhet støttes ikke");
      finished($form);
    }

    var votes = JSON.parse(localStorage.getItem("votes")) || {};
    if(votes[talk_id]) {
      finished($form);
    } else {
      bind($form, talk_id);
    }
  }

  function finished($form) {
    $form.empty();
    $form.append("<em>(Du har stemt)</em>");
    $form.show();
  }

  return {
    init: init,
    save_vote: save_vote
  };
})(jQuery);


//Document on load!
$(function() {
  $(".talk").each(function() {
    var talk_id = $(this).data("talkid"); 
      if(talk_id) {
        var voteTmpl = $("#tmplVote").tmpl({talk_id: talk_id});
        voteTmpl.find("input.star").rating();
        $(this).find(".description").append(voteTmpl);
        smidig.voter.init(voteTmpl, talk_id);
      }
  }); 
});





//Extensions to serialize a form to a js-object.
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