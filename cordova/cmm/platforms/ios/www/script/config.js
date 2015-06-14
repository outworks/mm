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
	back : function(url,reload,success,error){
		//-1
		var _ = this;
		if(_.cordova()){
			cordova.exec(success||function(){},error||function(){},'LKNav','backToPage',url=='-1'?url:[url,reload?'true':'false']);
		}else{
			url=='-1'?history.go(-1):(document.location.href = url);
		}
	},
	native:{
		upload : function(mediaFile,success,error,param){
			if(!window.FileTransfer){
				$f.isFunction(error)&&error();
				log('Upload Error');
				return;
			}
			var ft = new FileTransfer(),
            	path = mediaFile.fullPath;
            console.log(mediaFile.type);
            var _p = $f.object.toUrlString(param,true);
			ft.upload(path,
				PG.upload+(!!_p?'&'+_p:''),
				success||$.noop,
				error||$.noop,
                {fileKey:'file',fileName:path.substr(path.lastIndexOf('/') + 1),mimeType:mediaFile.type}
			);
		},
		//http://blog.csdn.net/mengxiangyue/article/details/8806638
		audio : function(success,error,limit){
			if(!navigator||!navigator.device||!navigator.device.capture){
				$f.isFunction(error)&&error();
				log('Audio Error');
				return;
			}
			navigator.device.capture.captureAudio(success||$.noop, error||$.noop, {limit:limit||1,duration: 60});
		},
		image : function(success,error,limit){
			if(!navigator||!navigator.device||!navigator.device.capture){
				$f.isFunction(error)&&error();
				log('Image Error');
				return;
			}
			navigator.device.capture.captureImage(success||$.noop, error||$.noop, {limit:limit||1});
		},
		video : function(success,error,limit){
			if(!navigator||!navigator.device||!navigator.device.capture){
				$f.isFunction(error)&&error();
				log('Image Error');
				return;
			}
			navigator.device.capture.captureVideo(success||$.noop, error||$.noop, {limit:limit||1});
		},
		//http://cordova.apache.org/docs/en/3.0.0/cordova_media_media.md.html#Media
		media : function(url,success,error){
			if(!window.Media){
				$f.isFunction(error)&&error();
				log('Media Error');
				return;
			}
			var media = new Media(url,success||$.noop, error||$.noop);
			return media;
		}
	},
	href : function(path,obj){
		if(!path)return '';
		return path+$f.object.toUrlString(obj);
	},
	path : function(){
		var head = 'http://123.57.45.235:8090/fz_yxjl/';
		var _path = {
			'userInfo':'MobileService?requestType=getNextTchUser',
			'billList':'MobileService?requestType=searchBill',
			'billType':'MobileService?requestType=billType',
			'billChannel':'MobileService?requestType=unitinfo',
			'billDetail':'MobileService?requestType=billDetails',
			'addBill':'MobileService?requestType=addBill'
		};
		return function(tar){
			return head+(_path[tar]||tar);
		}
	}(),
	upload : 'http://123.57.45.235:8090/fz_yxjl/MobileService?requestType=upload',
	resource : 'http://123.57.45.235:8090/file/',
	RS : {
		voice:4,
		image:4,
		video:4
	},
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
	relateChannel : {
		'1' : '所有',
		'2' : '个别'
	},
	history : 'HISTORY'
};
var TPL = {
	nocont : '<div class="nocont">暂无数据</div>',
	option : '<option value="{key}">{value}</option>',
	state : '<ul class="dropdown-menu" role="menu">\
		<% $.each(state,function(index,value){ %>\
			<li role="presentation">\
	            <a href="javascript:void(0);" class="b-filter-type" data-state="<%= value%>"><%=index%></a>\
	        </li>\
		<% }) %>\
	</ul>',
	order : '<% $.each(order,function(index,_order){ %>\
		<a href="javascript:void(0);" data-id="<%=_order.id%>" class="item">\
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
	detail : '<div class="title">工单详情:</div>\
        <div class="form-wrap container">\
            <div class="form-group">\
                <label for="" class="col-xs-3 control-label">工单号:</label>\
                <div class="col-xs-9 clearfix control">\
                    <span class="text"><%=order.billNum %></span>\
                </div>                                \
            </div>\
            <div class="form-group">\
                <label for="" class="col-xs-3 control-label">工单主题:</label>\
                <div class="col-xs-9 clearfix control">\
                    <span class="text"><%=order.billTitle %></span>\
                </div>                                \
            </div>\
            <div class="form-group">\
                <label for="" class="col-xs-3 control-label">工单类型:</label>\
                <div class="col-xs-9 clearfix control">\
                    <span class="text" data-type="<%=order.billType %>"><%=order.billTypeName%></span>\
                </div>                                \
            </div>\
            <div class="form-group">\
                <label for="" class="col-xs-3 control-label">涉及渠道:</label>\
                <div class="col-xs-9 clearfix control">\
                    <span class="text" data-channel="<%=order.relateChannel%>" data-channelIds="<%=order.relateChannelIds%>"><%=order.relateChannelString%></span>\
                </div>                                \
            </div>\
            <div class="form-group">\
                <label for="" class="col-xs-3 control-label">工单内容:</label>\
                <div class="col-xs-9 clearfix control">\
                    <span class="text">点击展开</span>\
                </div>                                \
            </div>\
            <div class="form-group">\
                <label for="" class="col-xs-3 control-label">提交时间:</label>\
                <div class="col-xs-9 clearfix control">\
                    <span class="text"><%=order.createTimeString%></span>\
                </div>                                \
            </div>\
        </div>\
        <div class="from-wrap container mt50">\
            <div class="steps">\
            	<% $.each(order.questionLogs,function(index,obj){ %>\
				<div class="step  <%=!obj.finishTimeString?\'cur\':\'\'%>">\
                    <span class="index"><%=index+1%></span>\
                    <div class="info container">\
                        <div class="row">\
                            <span class="col-xs-7 tit"><%=obj.tchName%></span>\
                            <% if(!!obj.userName){%>\
                            	<span class="col-xs-5 tc name"><i class="i i-user"></i><%=obj.userName%></span>\
                            <% } %>\
                        </div>\
                        <div class="row">\
                            <span class="col-xs-4 tit">操作类型：</span>\
                            <span class="col-xs-8 txt"><%=obj.logTypeName%></span>\
                        </div>\
                        <div class="row">\
                            <span class="col-xs-4 tit">处理意见：</span>\
                            <span class="col-xs-8 txt"><%=obj.logContent%></span>\
                        </div>\
                    </div>\
                    <% if(obj.finishTimeString){ %>\
                    <p class="time">\
                        <i class="i i-time"></i><%=obj.finishTimeString%>\
                    </p>\
                    <% } %>\
                </div>\
            	<% }) %>\
            </div>\
        </div>',
    save : '<div class="title">详细信息:</div>\
	    <div class="form-wrap container">\
	        <div class="form-group">\
	            <label for="" class="col-xs-3 control-label">提单人:</label>\
	            <div class="col-xs-9 clearfix control">\
	                <span class="text"><%=order.userName%></span>\
	            </div>                                \
	        </div>\
	        <div class="form-group">\
	            <label for="" class="col-xs-3 control-label">联系方式:</label>\
	            <div class="col-xs-9 clearfix control">\
	                <span class="text"><%=order.mobilePhone%></span>\
	            </div>                                \
	        </div>\
	        <div class="form-group">\
	            <label for="" class="col-xs-3 control-label">归属县区:</label>\
	            <div class="col-xs-9 clearfix control">\
	                <span class="text"><%=order.regionName%></span>\
	            </div>                                \
	        </div>\
	        <div class="form-group">\
	            <label for="" class="col-xs-3 control-label">归属片区:</label>\
	            <div class="col-xs-9 clearfix control">\
	                <span class="text"><%=order.orgName%></span>\
	            </div>                                \
	        </div>\
	        <div class="form-group">\
	            <label for="" class="col-xs-3 control-label">订单时间:</label>\
	            <div class="col-xs-9 clearfix control">\
	                <span class="text"><%=order.createTime%></span>\
	            </div>                                \
	        </div>\
	    </div>\
	    <div class="title">下一步代理人:</div>\
	    <div class="form-wrap container">\
	        <div class="form-group">\
	            <div class="col-xs-12 clearfix">\
	                <select name="type" class="control-select">\
	                	<% $.each(users,function(index,user){ %>\
							<option value="<%=user.userId%>"><%=user.userName%></option>\
	                	<% })%>\
	                </select>\
	            </div>                                \
	        </div>\
	    </div>\
	    <div class="from-group container mt20 mb20">\
	        <button href="javascript:void(0);" data-type="2" class="b-save c2">暂存</button>\
	    </div>\
	    <div class="from-group container mt20 mb20">\
	        <button href="javascript:void(0);" data-type="1" class="b-submit c1">提交</button>\
	    </div>',
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
		},
		detail : function(detail){
			var _tpl = $f.template(TPL.detail);
			return _tpl({order:detail});
		},
		save : function(save,users){
			var _tpl = $f.template(TPL.save);
			return _tpl({order:save,users:users});
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
			var $elem = $('<div class="pop pop-load"><div class="box"></div></div>');
			$elem.bind('touchmove',function(e){
				e.preventDefault();  
				e.stopPropagation(); 
				return false;
			});
			return {
				show : function(){
					$elem.appendTo('body').show();
					$elem.addClass('animated ffast fadeIn');
					return this;
				},
				hide : function(func){
					if(!$elem)return null;
					$elem.removeClass('fadeIn').addClass('fadeOut');
					_.bind.call($elem,function(){
						$elem.remove();
						$elem = null;
						$.isFunction(func)&&func();
					});
					return this;
				},
				elem:$elem
			}
		},
		resource : function(){
			var _ = this;
			var $elem = $('<div class="pop pop-resource"><div class="mask"></div><div class="box"></div></div>');
			$elem.bind('touchmove',function(e){
				e.preventDefault();  
				e.stopPropagation(); 
				return false;
			});
			return {
				show : function(){
					$elem.appendTo('body').show();
					$elem.addClass('animated ffast fadeIn');
					return this;
				},
				hide : function(func){
					if(!$elem)return null;
					$elem.removeClass('fadeIn').addClass('fadeOut');
					_.bind.call($elem,function(){
						$elem.remove();
						$elem = null;
						$.isFunction(func)&&func();
					});
					return this;
				},
				bg : function(src){
					$elem.find('.box').css({backgroundImage:'url('+src+')'});
					return this;
				},
				video : function(src){
					var str = '<video class="mp4" autoplay="autoplay" controls="controls" name="media" src="{path}"></video>'.replace('{path}',src);
					var $video = $(str).appendTo($elem.find('.box'));
					return this;
					// return '<div class="videobox"><video class="mp4" autoplay="autoplay" controls="controls" name="media" src="{path}"></video><a href="javascript:;" class="btn b-close"></a></div>'.replace('{path}',src);
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
			var _userId = url['userId']||$f.db.get('pageUserId');
			$f.db.remove('pageUserId');
			$f.db.set('userId',_userId);
			var _u = $f.db.get('userInfo');
			if(_u && _u.userId == _userId){
				userInfo = _u;
				$f.isFunction(func)&&func();
			}else{
				var $load = $f.pop.load();
				$load.show();
				$f.db.remove('userInfo');
				$f.db.remove('nextTchUser');
				$f.ajax({
					url:PG.path('userInfo'),
					option:{userId:_userId},
					success:function(json){
						if(json.result=='0'&&json.data){
							var _userInfo = json.data.userInfo;
							$f.db.set('userInfo',_userInfo);
							$f.db.set('nextTchUser',json.data.nextTchUser);
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
			return _.hasUpdate($f.db.get('typeTime'))&&$f.db.get('type')
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
		},
		channel : function(){
			var _ = this;
			return _.hasUpdate($f.db.get('channelTime'))&&$f.db.get('channel')
				?$.Deferred(function(dtd){dtd.resolve();})
				:$f.ajax({
					url:PG.path('billChannel'),
					option:{},
					success:function(json){
						if(json.result=='0'&&json.data){
							$f.db.set('channelTime',new Date().format('yyyy-MM-dd'));
							$f.db.set('channel',json.data);
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