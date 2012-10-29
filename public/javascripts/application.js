function externalLinks() {   
  if (!document.getElementsByTagName) return;   
    var anchors = document.getElementsByTagName("a");   
  for (var i=0; i<anchors.length; i++) {   
    var anchor = anchors[i];   
    if (anchor.getAttribute("href") && anchor.getAttribute("rel") == "external")   
      anchor.target = "_blank";   
  }
}

function onApplicationLoad() {
  externalLinks();
}

window.onload = onApplicationLoad;

$(window).on("scroll resize", function(){
  var pos=$('.location-explanation .time').offset();
    if(!pos) {
      return;
    }
    if(pos.top < $('h3.time').eq(0).offset().top) {
      $('.location-explanation .time').html(""); 
    } else {
      $('h3.time').each(function(){
          if(pos.top >= $(this).offset().top && 
             pos.top < $(this).next().offset().top || pos.top > $(this).next().offset().top)
          {
              // any way you want to get the date
              $('.location-explanation .time').html($(this).html()); 
              return; //break the loop
          }
      });
    }
});

$(function() {
	$(".tooltip-link").each(function() {
		$(this).simpletip({ content: $(this).attr('data-tooltip')});
	});

  $(window).trigger('scroll');

  $('.program .slot .talk h3').on('click', function(event) {
    $(event.target).closest('.talk').find('.description').slideToggle();
  });
});

$(function() {
  if($.browser.msie) {
    $(".browserinfo").text("NB: Programmet er laget for Chrome, Safari, Firefox og IE9. Eldre versjoner av IE får en kjip versjon. Du bruker IE" + $.browser.version);
  }
});