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
//= require jquery.notifyBar
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

  $(document).bind('reveal.facebox', function() {
    $('#facebox input[type=submit]').attr('disabled', true);

    $('#facebox input.file').change(function() {
      file_name = $(this).val();
      pattern = /(bnsales.*xls)|(salesreport.*xls)|(kdp-report.*xls)$/i

      if (pattern.test(file_name)) {
        $('#facebox input[type=submit]').attr('disabled', false);
        $('#facebox .warning').hide();
      } else {
        $('#facebox input[type=submit]').attr('disabled', true);
        $('#facebox .warning').show();
        $('#facebox .warning').effect("bounce", { direction:'down', times:3, distance: 10 }, 200);
      }
    })
  })
})

