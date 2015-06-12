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
        alert(JSON.stringify(url));
		_.cssInit();
		_.pageInit();
		_.render();
	},
	cssInit:function(){
		var _ = this;
		alert('cssInit')
		$('.b-save,.b-submit').bind('click', function(e) {
			e.preventDefault();  
			e.stopPropagation(); 
			alert(1);
                                    
			/*if(_flag)return;
			var $load = $f.pop.load();
			$load.show();
			_flag = true;
			$f.ajax({
				url:PG.path('addBill'),
				option:$({},url,{
					regionId:userInfo.regionId,
					orgId:userInfo.orgId,
					nextTchUser:$('control-select').val(),
					type:$(this).data('type')
				}),
				success:function(json){
					if(json.result=='0'&&json.data){
						PG.back('-1');
					}else{
						alert(json.message);
					}
				},
				error:function(){
					alert('请求失败');
				},
				complete:function(){
					_flag = false;
					$load.hide();
				}
			});*/
			return false;
		});
	},
	pageInit:function(){
		var _ = this;

		$('.b-back').bind('touchstart click',function(){
			PG.close();
		});
	},
	render:function(){
		var $load = $f.pop.load();
		$load.show();
		_flag = true;
		log(_url);
		var cont = $f.page.save(_url,$f.db.get('nextTchUser'));
		$save.append(cont||TPL.nocont);
		setTimeout(function(){
			$load.hide();
		},500);
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