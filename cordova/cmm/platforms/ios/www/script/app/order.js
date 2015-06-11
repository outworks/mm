!function($){

var $order = $('.orders');
var _first = true,
	_flag = false,
	_has = true,
	_orderDir = {
		'up':'ASC',
		'down':'DESC'
	},
	userId , userInfo ,
	_param = {
		userId : null,
		billTitle : '',
		createTimeBegin : '',
		createTimeEnd : '',
		billType : '',
		state : '',
		curPageNum : 1,
		pageSize : 10,
		orderDirection : 'ASC'
	};
var Page = {
	init : function(){
		var _ = this;
		_param.userId = userId = $f.db.get('userId');
		_.cssInit();
		_.render();
		_.pageInit();
	},
	cssInit:function(){
		var _ = this;
		//dropdown
		$('.dropdonw-state').append($f.page.state());
		//time dir
		$('.b-time').bind('click', function(event) {
			if(_flag)return;
			var dir = !$(this).hasClass('down')?'down':'up';
			$(this).attr('class','b-time '+dir);
			_.setParam({orderDirection:_orderDir[dir]});
			_.render();
		});
		// dropmenu
		$('.b-filter-type').bind('click', function(event) {
			if(_flag)return;
			_.setParam({state:$(this).data('state')},true);
			_.render();
		});

		// search
		var _state1_ = false;
		$('.b-filter').bind('click', function(event) {
			if(_state1_)return;
			_state1_ = true;
			var data = {
				state : PG.stateClass,
				type : $f.db.get('type'),
				history : $f.db.get(PG.history)
			}
			var $sc = $f.pop.search(data);
			$sc.show(function(){
				var $scroll = $f.pop.scroll($sc.elem.find('.box'));
				$sc.elem.find('.checklabel').bind('touchstart click',function(){
					var input = $(this).prev('input');
					!input[0].checked?(input[0].checked = true):(input[0].checked = false);
				});

				var $inpsch = $sc.elem.find('.inp-search'),$form = $sc.elem.find('.search');
				$inpsch.bind('keyup', function(event) {
					if(!$(this).val()){
						$(this).removeClass('has');
					}else{
						$(this).addClass('has');
					}
				});
				$sc.elem.find('.b-tosearch').bind('click', function(event) {
					var param = $f.api.serializeObject($form.serializeArray());

					param.billTitle = $inpsch.val();
					param.state = !param.state?'':param.state.join(',');
					param.createTimeBegin&&(param.createTimeBegin += ' 00:00:00');
					param.createTimeEnd&&(param.createTimeEnd += ' 23:59:59');

					if(!!param.billTitle){
						var $his = $f.db.get(PG.history);
						$his = $his || [];
						var _obj = {
							key : param.billTitle,
							value : param
						};
						if($his.length>=3){
							$his.shift();
						}
						$his.push(_obj);
						$f.db.set(PG.history,$his);
					}
					_.doSearch(param);
					$sc.hide();
					// $sc.hide();
				});

				$sc.elem.find('.b-clear').bind('click', function(event) {
					$sc.elem.find('.history').remove();
					$f.db.set(PG.history,[]);
				});

				var $btnhis = $sc.elem.find('.b-history')
				$btnhis.bind('click touchstart', function(event) {
					var index = $btnhis.index(this),
						$his = $f.db.get(PG.history),
						param = $his[index].value;
					_.doSearch(param);
					$sc.hide();
				});
			});
			$sc.elem.one('hide',function(){
				_state1_ = false;
			});
		});
	
		_.buttonInit();
	},
	doSearch:function(param){
		var _ =this;
		_.setParam(param,true);
		_.render();
	},
	pageInit:function(){
		var _ = this;

		$('.b-back').bind('touchstart click',function(){
			PG.close();
		});
		$('.b-create').bind('touchstart click',function(){
			PG.open('create.html'+$f.object.toUrlString({userId:userId}));
		});
		$('.orders').on('click', '.item', function(event) {
			event.preventDefault();
			PG.open('detail.html'+$f.object.toUrlString({userId:userId}));
		});
	},
	buttonInit:function(){
        /*$('body').on('touchend','a,button',function(){
        	$(this).blur();
        });*/
	},
	resetParam : function(deep){
		var _o = {
			curPageNum : 1//,
			// orderDirection : 'ASC'
		},_deep = {
			billTitle : '',
			createTimeBegin : '',
			createTimeEnd : '',
			state : '',
			billType : undefined
		}
		$.extend(_param,_o,!deep?{}:_deep);
		_first = true;
		_has = true;
	},
	setParam : function(obj,flag){
		var _ = this;
		_.resetParam(flag);
		$.extend(_param,obj);
	},
	render : function(){
		if(!_has)return;
		if(_flag)return;
		var _ = this;
		var $load = _first?$f.pop.load():$('.load');
		$load.show();
		_flag = true;
		var $load = $load
		$f.ajax({
			url:PG.path('billList'),
			option:_param,
			success:function(json){
				if(json.result=='0'&&json.data){
					var data = json.data.result;
					$.each(data,function(index, el) {
						var _st = PG.stateClass[el.state||10];
						data[index]['stateClass'] = _st[0];
						data[index]['stateString'] = _st[1];
						data[index]['createTimeString'] = new Date(el.createTime).format('yyyy-MM-dd hh-mm');
					});
					var cont = $f.page.order(data);
					if(_first){
						$order.empty();
						$(window).scrollTop(0);
						if(!cont){
							cont = TPL.nocont;
						}
					}
					$order.append(cont);
				}
				_has = json.data?json.data.hasNextPage : false;
				if(_has){
					_.scroll();
				}
			},
			error:function(){
				if(_first){
					$order.empty().append(TPL.nocont);
				}
				_has = false;
			},
			complete:function(){
				_flag = false;
				_first = false;
				$load.hide();
			}
		})
	},
	scroll : function(){
		var _ = this;
		var $win = $(window),$doc = $(document);
		$win.bind('scroll', function(event) {
			if(!!_has&&!_flag){
				var trigger = ($win.scrollTop() + $win.height() > $doc.height() - 50);
				if(trigger){
					_param.curPageNum ++ ;
					$win.unbind('scroll');
					_.render();
				}
	      	}
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