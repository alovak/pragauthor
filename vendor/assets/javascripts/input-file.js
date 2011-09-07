(function($) {
	$.fn.jInputFile = function(options) {
		
		return this.each(function() {
			$$ = $(this);
			$$.val('');
			$$.wrap('<div></div>');
			$$.parent().css('height',$$.height());
			$$.after('<div class="jInputFile-fakeButton"></div><div class="jInputFile-blocker"></div><div class="jInputFile-activeBrowseButton jInputFile-fakeButton"></div><div class="jInputFile-fileName"></div>');
			$$.addClass('jInputFile-customFile');
		
			$$.hover(
				function () {
					$$.parent().children('.jInputFile-activeBrowseButton').css('display', 'block');
				},
				function () {
					$$.parent().children('.jInputFile-activeBrowseButton').css('display', 'none');
				}
			);
		
			$$.change(function(){
                          $('form').submit();
                          // var file = $$.val();

                          // var reWin = /.*\\(.*)/;
                          // var fileName = file.replace(reWin, '$1');
                          // var reUnix = /.*\/(.*)/;
                          // fileName = fileName.replace(reUnix, '$1');
                          // var regExExt =/.*\.(.*)/;
                          // var ext = fileName.replace(regExExt, '$1');

                          // var pos;
                          // if (ext){
                            // switch (ext.toLowerCase()) {
                              // case 'doc': pos = '0'; break;
                              // case 'bmp': pos = '16'; break;                       
                              // case 'jpg': pos = '32'; break;
                              // case 'jpeg': pos = '32'; break;
                              // case 'png': pos = '48'; break;
                              // case 'gif': pos = '64'; break;
                              // case 'psd': pos = '80'; break;
                              // case 'mp3': pos = '96'; break;
                              // case 'wav': pos = '96'; break;
                              // case 'ogg': pos = '96'; break;
                              // case 'avi': pos = '112'; break;
                              // case 'wmv': pos = '112'; break;
                              // case 'flv': pos = '112'; break;
                              // case 'pdf': pos = '128'; break;
                              // case 'exe': pos = '144'; break;
                              // case 'txt': pos = '160'; break;
                              // default: pos = '176'; break
                            // };
                            // $$.parent().children('.jInputFile-fileName').html(fileName).css({'background-position':('0px -'+pos+'px'),'background-repeat':'no-repeat', 'display':'block'});
                          // };	
                        });	
                });
        }
})(jQuery);

