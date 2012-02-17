//= require jquery
//= require jquery_ujs
//= require jquery-ui-1.8.16.custom.min
//= require facebox
//

var tag = document.createElement('script');
tag.src = "http://www.youtube.com/player_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

var player;
function onYouTubePlayerAPIReady() {
  player = new YT.Player('player', {
    height: '360',
    width: '640',
    videoId: 'V1uW-2wnGoE',
    events: {
      'onReady': set_facebox_collbacks,
    }
  });
}

function set_facebox_collbacks() {
  $(document).bind('reveal.facebox', function() {
    player.startVideo();
  });

  $(document).bind('afterClose.facebox', function(){
    player.stopVideo();
  });
}

jQuery(document).ready(function($) {
  $.facebox.settings.closeImage = '/assets/facebox/closelabel.png';
  $.facebox.settings.loadingImage = '/assets/facebox/loading.gif';
  $('a[rel*=facebox]').facebox();
});
