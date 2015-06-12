!function($){

var $detail = $('.detail');
var userId , userInfo , billId ;
var url = $f.api.urlparam();
var _flag = false;
var _detail = {};

var Page = {
	init : function(){
		var _ = this;
		userId = $f.db.get('userId');
		userInfo = $f.db.get('userInfo');
		billId = url['billId'];
		_.pageInit();
		_.render();
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
	},
	render:function(){
		if(_flag)return;
		var $load = $f.pop.load();
		$load.show();
		_flag = true;
		$f.ajax({
			url:PG.path('billDetail'),
			option:{
				userId : userId,
				billId : billId
			},
			success:function(json){
				if(json.result=='0'&&json.data){
					var data = json.data;
					data['relateChannelString'] = PG.relateChannel[data['relateChannel']];
					log(data.questionLogs.length);
					var cont = $f.page.detail(data);
					$detail.append(cont);
					_detail = data;
				}else{
					$detail.append(TPL.nocont);
				}
			},
			error:function(){
				$detail.append(TPL.nocont);
			},
			complete:function(){
				_flag = false;
				$load.hide();
			}
		});
	}
};

$(function(){
	$f.req.user(function(){
		Page.init();
	});
})

}(jQuery);