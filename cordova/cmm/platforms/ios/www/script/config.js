/*
	config
*/

/*
 function openUrl(url){
    LKNav.openPage(url,'关闭和原生',function(){},function(){},'NO');
}
function closePage(){
    LKNav.closePage();
}

*/
var PG = {
	cordova : function(){
		return !!window.cordova;
	},
	open : function(url,title,hiddenNav,success,error){
		var _ = this;
		if(_.cordova()){
            cordova.exec(success||function(){},error||function(){},'LKNav','openPage',[url,title||'',hiddenNav||'YES']);
		}else{
			document.location.href = url;
		}
	},
	close : function(success,error){
		var _ = this;
		if(_.cordova()){
            cordova.exec(success||function(){},error||function(){},'LKNav','closePage',[]);
		}else{
			history.go(-1);
		}
	},
	back : function(url,success,error){
		var _ = this;
		if(_.cordova()){
			cordova.exec(success||function(){},error||function(){},'LKNav','backToPage',[url]);
		}else{
			document.location.href = url;
		}
	},
	path : function(){
		var head = 'http://123.57.45.235:8090/fz_yxjl/';
		var _path = {
			'userInfo':'MobileService?requestType=getNextTchUser',
			'billList':'MobileService?requestType=searchBill',
			'billType':'MobileService?requestType=billType'
		};
		return function(tar){
			return head+(_path[tar]||tar);
		}
	}(),
	state : {
		'全部':'',//10,11,12,13,14,15
		'处理中':'10',
		'草稿箱':'11',
		'待评价':'12',
		'已中止':'13',
		'已撤回':'14',
		'已办结':'15'
	},
	stateClass : {
		'10' : ['s-1','处理中'],
		'12' : ['s-2','待评价'],
		'15' : ['s-3','已办结'],
		'14' : ['s-4','已撤回'],
		'13' : ['s-4','已中止'],
		'11' : ['s-4','草稿箱']
	},
	history : 'HISTORY'
};
var TPL = {
	nocont : '<div class="nocont">暂无数据</div>',
	state : '<ul class="dropdown-menu" role="menu">\
		<% $.each(state,function(index,value){ %>\
			<li role="presentation">\
	            <a href="javascript:void(0);" class="b-filter-type" data-state="<%= value%>"><%=index%></a>\
	        </li>\
		<% }) %>\
	</ul>',
	order : '<% $.each(order,function(index,_order){ %>\
		<a href="javascript:void(0);" class="item">\
            <span class="state <%=_order.stateClass%>"><%=_order.stateString%></span>\
            <div class="info container">\
                <div class="row">\
                    <span class="col-xs-4 oid"><%=_order.billNum%></span>\
                    <span class="col-xs-3 tc name"><%=_order.userName%></span>\
                    <span class="col-xs-5 tr time"><%=_order.createTimeString%></span>\
                </div>\
            </div>\
            <p class="title">\
                <%= _order.billTitle %>\
            </p>\
        </a>\
	<% }) %>',
	search :'<div class="pop pop-search">\
		<div class="mask"></div>\
        <div class="box">\
        	<div class="wrap">\
            <div class="head">\
                <div class="inp-wrap">\
                    <input type="text" class="inp inp-search">\
                    <div class="line"></div>\
                </div>\
                <button href="javascript:void(0);" class="b b2 b-tosearch button">搜索</button>\
                <i class="i i-conner"></i>\
            </div>\
            <div class="body">\
                    <form class="form-horizontal search container">\
                        <div class="form-group">\
                            <label for="" class="col-xs-12 control-label">提交时间:</label>\
                            <div class="col-xs-12 clearfix control-dates">\
                                <input type="date" name="createTimeBegin" class="inp inp-date inp-start">\
                                <span class="tip">至</span>\
                                <input type="date" name="createTimeEnd" class="inp inp-date inp-end"> \
                            </div>                                \
                        </div>\
                        <div class="form-group">\
                            <label for="" class="col-xs-4 control-label">故障类型:</label>\
                            <div class="col-xs-8 clearfix">\
                                <select name="billType" class="control-select">\
                                	<option value="">所有</option>\
                                    <% $.each(type,function(index,value){ %>\
		                        		<option value="<%=value.id%>"><%=value.titile %></option>\
		                        	<% }) %>\
                                </select>\
                            </div>\
                        </div>\
                        <div class="form-group">\
                            <label for="" class="col-xs-4 control-label">当前状态:</label>\
                            <div class="col-xs-8 clearfix control-checkboxs">\
                            	<% $.each(state,function(index,value){ %>\
								<div class="col-xs-6 checkbox">\
                                    <input id="checkbox-<%=index%>" name="state" type="checkbox" value="<%=index%>">\
                                    <label class="checklabel"><%=value[1]%></label>\
                                </div>\
                            	<% }) %>\
                            </div>\
                        </div>\
                        <div class="form-group">\
                            <button type="reset" href="javascript:void(0);" class="b b2 b-reset button">重置</button>\
                        </div>\
                    </form>\
                    <div class="history">\
                    	<% if(!!history&&history.length>0){ %>\
                        <div class="title">历史记录:</div>\
                        <div class="his-list">\
                        	<% $.each(history,function(index,obj){ %>\
                        		<a href="javascript:void(0);" class="b b-history"><%=obj.key %></a>\
                        	<% }) %>\
                        </div>\
                        <button type="reset" href="javascript:void(0);" class="b b2 b-clear button">清空历史数据</button>\
                        <% } %>\
                    </div>\
            </div>\
            </div>\
        </div>\
    </div>',
	stop : {

	},
	end : {

	},
	cont : {

	}
};

!function($){
	$f.page = {
		state : function(){
			var _tpl = $f.template(TPL.state);
			return _tpl({state:PG.state});
		},
		order : function(od){
			od = od || [];
			var _tpl = $f.template(TPL.order);
			return _tpl({order:od});
		}
	};
	$f.pop = {
		bind : function(){
			var args = Array.prototype.slice.call(arguments);
			var func = args.shift();
			this.one('webkitAnimationEnd animationend', function(){
				$f.isFunction(func)&&func.apply(this,args);
			});
		},
		show : function($$,cls,func){
			var _ = this,$tar = $$.elem,
				$box = $tar.find('.box'),$mask = $tar.find('.mask');

			$tar.appendTo('body');
			$box.css({visibility:'hidden'});
			$mask.css({visibility:'hidden'});
			$tar.show();
			setTimeout(function(){
				$mask.addClass('animated fast fadeIn').css({visibility:'visible'});
				$box.addClass('animated '+cls).css({visibility:'visible'});
				_.bind.call($box,function(){
					$f.isFunction(func)&&func();
					$mask.one('touchstart click',function(){
						$$.hide();
					});
				})
			},100);
		},
		hide : function($$,cls1,cls2,func){
			var _ = this,$tar = $$.elem,
				$box = $tar.find('.box'),$mask = $tar.find('.mask');

			$mask.removeClass('fadeIn').addClass('fadeOut');
			$box.removeClass(cls1).addClass(cls2);
			_.bind.call($box,function(){
				$tar.remove();
				$load = null;
				$.isFunction(func)&&func();
			});
		},
		load : function(){
			var _ = this;
			var $elem = $('<div class="pop pop-load"></div>');
			$elem.bind('touchmove',function(e){
				e.preventDefault();  
				e.stopPropagation(); 
				return false;
			});
			return {
				show : function(){
					$elem.appendTo('body').show();
					$elem.addClass('animated ffast fadeIn');
				},
				hide : function(func){
					$elem.removeClass('fadeIn').addClass('fadeOut');
					_.bind.call($elem,function(){
						$elem.remove();
						$elem = null;
						$.isFunction(func)&&func();
					});
				},
				elem:$elem
			}
		},
		search : function(data){
			var _ = this;
			var _tpl = $f.template(TPL.search),
				$elem = $(_tpl(data));
			return {
				show : function(func){
					var _this = this;
					_.show(_this,'ffast fadeInRight',func);
				},
				hide : function(func){
					var _this = this;
					_.hide(_this,'fadeInRight','fadeOutRight',func);
					_this.elem.trigger('hide');
				},
				elem:$elem
			}
		},
		scroll:function($tar){
			return new IScroll($tar[0], {
				zoom: true,
				scrollbars: true,
				interactiveScrollbars: true,
				shrinkScrollbars: 'scale',
				fadeScrollbars: false
			});
		}
	};
	$f.req = {
		hasUpdate : function(time){
			return time&&(time==new Date().format('yyyy-MM-dd'));
		},
		user : function(func){
			var url = $f.api.urlparam();
			var _userId = url['userId'];
			$f.db.set('userId',_userId);
			var _u = $f.db.get('userInfo');
			if(_u && _u.userId == _userId){
				userInfo = _u;
				$f.isFunction(func)&&func();
			}else{
				var $load = $f.pop.load();
				$load.show();
				$f.db.remove('userInfo');
				$f.ajax({
					url:PG.path('userInfo'),
					option:{userId:_userId},
					success:function(json){
						if(json.result=='0'&&json.data){
							var _userInfo = json.data.userInfo;
							$f.db.set('userInfo',{
								userName:_userInfo.userName,
								userId:_userInfo.userId,
								userType:_userInfo.userType
							});
						}
					},
					complete:function(){
						// log($load);
						$load.hide();
						// alert(1)
						$f.isFunction(func)&&func();
					}
				})
			}
		},
		type : function(){
			var _ = this;
			return _.hasUpdate($f.db.get('typeTime'))
				?$.Deferred(function(dtd){dtd.resolve();})
				:$f.ajax({
					url:PG.path('billType'),
					option:{userId:$f.db.get('userId')},
					success:function(json){
						if(json.result=='0'&&json.data){
							$f.db.set('typeTime',new Date().format('yyyy-MM-dd'));
							$f.db.set('type',json.data);
						}
					}
				})
		}
	}
}(jQuery);

// $f.db.empty();

function log(msg) {
    if (window.console && window.console.log)
        window.console.log.apply(console,arguments);//+"|date:"+new Date().getTime()
    else if (window.opera && window.opera.postError)
        window.opera.postError(opera,arguments);
};