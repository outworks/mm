!function($){
	var $pop = $('.pop'),$box = $('.pop .box');
	$pop.show();
	$box.css({visibility:'hidden'});
	// alert($box.height());
	$box.css({marginTop:-$box.height()/2});

	$box.css({visibility:'visible'}).addClass('animated fast fadeInUp');
	$box.one('webkitAnimationEnd animationend', function(){
		/*$box.removeClass('zoomIn').addClass('zoomOut').one('webkitAnimationEnd animationend',function(){
			$box.removeClass('zoomOut').hide();
		});*/
	});
}(jQuery)