// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//= require facebox
//

jQuery(document).ready(function($) {
  $.facebox.settings.closeImage = '/assets/facebox/closelabel.png'
  $.facebox.settings.loadingImage = '/assets/facebox/loading.gif'
  $('a[rel*=facebox]').facebox()

  $("div.column").mouseenter(function(){
    $(this).addClass('selected')
    month = $(this).siblings('.label').text();
    $(this).parents('.barchart').siblings(".month" + "." + month).show();
    
  }).mouseleave(function(){
    $(this).removeClass('selected')
    month = $(this).siblings('.label').text();
    $(this).parents('.barchart').siblings(".month" + "." + month).hide();
  });
})
