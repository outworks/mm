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
		$('.b-save,.b-submit').bind('touchstart click',function(e){
			e.preventDefault();  
			e.stopPropagation(); 
			PG.back('order.html'+$f.object.toUrlString({userId:userId}));
			return false;
		});
	}
};

$(function(){
	$f.req.user(function(){
		$f.req.type().always(function(){
			Page.init();
		})
	});
})

}(jQuery);