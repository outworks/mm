!function($){

var $save = $('.save');
var userId , userInfo ;
var url = $f.db.get('save'),_url ;//$f.api.urlparam()
$f.db.remove('save');
var _flag = false;
var Page = {
	init : function(){
		var _ = this;
		userId = $f.db.get('userId');
		userInfo = $f.db.get('userInfo');
		_url = $.extend({},url,userInfo);
		_.cssInit();
	},
	cssInit:function(){
		var _ = this;
		_.pageInit();
		_.render();
	},
	pageInit:function(){
		var _ = this;

		$('.b-back').bind('touchstart click',function(){
			PG.close();
		});
	},
	render:function(){
		var _ = this,
			$load = $f.pop.load();
		$load.show();
		_flag = true;
		var cont = $f.page.save(_url,$f.db.get('nextTchUser'));
		$save.append(cont||TPL.nocont);
		setTimeout(function(){
			_flag = false;
			$load.hide();
			_.btnInit();
		},500);
	},
	btnInit:function(){
		$('.b-save,.b-submit').on('click', function(e) {
			e.preventDefault();  
			e.stopPropagation(); 
			if(_flag)return;
			var $load = $f.pop.load();
			$load.show();
			_flag = true;
			$f.ajax({
				url:PG.path('addBill'),
				option:$.extend({},url,{
					regionId:userInfo.regionId,
					orgId:userInfo.orgId,
					nextTchUser:$('.control-select').val(),
					submitType:$(this).data('type')
				}),
				success:function(json){
					if(json.result=='0'){
						PG.back(PG.href('order.html',{userId:userId}),true);
					}else{
						alert(json.msg);
					}
				},
				error:function(){
					alert('请求失败');
				},
				complete:function(){
					_flag = false;
					$load.hide();
				}
			});
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