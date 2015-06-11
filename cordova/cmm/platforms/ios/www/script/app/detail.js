!function($){

var $order = $('.orders');
var userId , userInfo ;
var Page = {
	init : function(){
		var _ = this;
		userId = $f.db.get('userId');
		userInfo = $f.db.set('userInfo');
		_.pageInit();
	},
	cssInit:function(){
		var _ = this;
		
	},
	pageInit:function(){
		var _ = this;

		$('.b-back').bind('touchstart click',function(){
			PG.close();
		});
		$('.b-stop,.b-rollback').bind('touchstart click',function(e){
			e.preventDefault();  
			e.stopPropagation(); 
			return false;
		});
	}
};

$(function(){
	$f.req.user(function(){
		Page.init();
	});
})

}(jQuery);