!function($){

var $save = $('.save');
var userId , userInfo ;
var url ,_url ,nextTchUser ;

var _flag = false;
var Page = {
	init : function(){
		log('init');
		var _ = this;
		userId = $f.db.get('userId');
		userInfo = $f.db.get('userInfo');

		url = $f.db.get('save');
		$f.db.remove('save');
		_url = $.extend({},url,userInfo);

		nextTchUser = $f.db.get('nextTchUser') || [];
		$f.db.remove('nextTchUser');
		_.cssInit();
	},
	cssInit:function(){
		var _ = this;
		_.pageInit();
		_.render();
	},
	pageInit:function(){
		var _ = this;

		$('.b-back').bind('click',function(){
			PG.close();
		});
	},
	render:function(){
		var _ = this,
			$load = $f.pop.load();
		$load.show();
		_flag = true;
		var cont = $f.page.save(_url,nextTchUser);
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
						$f.pop.tip(json.msg).show(function(){
							PG.back(PG.href('index.html',{userId:userId}),'true');
						});
					}else{
						$f.pop.tip(json.msg).show();
					}
				},
				error:function(){
					$f.pop.tip('请求失败').show();
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
		var $load = $f.pop.load().show();
		$.when($f.req.type(),$f.req.nextUser()).always(function(){
			Page.init();
			$load.hide();
		})
	});
})

}(jQuery);