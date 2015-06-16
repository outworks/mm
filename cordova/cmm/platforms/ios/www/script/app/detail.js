!function($){

var $detail = $('.detail');
var userId , userInfo , billId ;
var url = $f.api.urlparam();
var _flag = false;
var _detail = {},$btns;

var Page = {
	init : function(){
		var _ = this;
		userId = $f.db.get('userId');
		userInfo = $f.db.get('userInfo');
		billId = url['billId'];
		_.cssInit();
		_.pageInit();
		_.render();
	},
	cssInit:function(){
		var _ = this;
		_.btnInit();
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
		var _ = this;
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
					if(!!data.relateChannelIds){
						data.relateChannelIds = data.relateChannelIds.split(',');
						data.relateChannelArr = [];
						var channels = $f.db.get('channel'); 
						$.each(data.relateChannelIds, function(index, val) {
							var flag = false;
							for(var i=0;i<channels.length;i++){
								if(!flag&&val==channels[i].id){
									data.relateChannelArr.push(channels[i]);
									flag = true;
								}
							}
						});
					};
					// log(data.questionLogs.length);
					var cont = $f.page.detail(data);
					$detail.append(cont);
					_detail = data;
					_.stateHandle(_detail.state);
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
	},
	stateHandle:function(state){
		var _=this,bobj = {
			10:['stop','cancel'],//处理中
			11:['edit','delete'],//草稿箱
			12:['eval'],//待评价
			13:[],//已中止
			14:['edit','delete'],//已撤回
			15:['showeval']//已办结
		};
		$btns = $('.buttons');
		$.each(bobj[state], function(index, val) {
			 _.button[val]();
		});
		 _.button.detail();
	},
	button:{
		detail:function(){
			var $btn = $('.opentext');
			$btn.bind('click', function(event) {
				// PG.resource()
				// PG.playpath()
				var arrs = [_detail.voice?_detail.voice.split(','):[],
							_detail.image?_detail.image.split(','):[],
							_detail.video?_detail.video.split(','):[]]
				for(var i=0;i<arrs.length;i++){
					$.each(arrs[i],function(index, el) {
						arrs[i][index] = (i==2?PG.playpath():PG.resource())+el;
					});
				}
				var $pop = $f.pop.stage('cont',{
					cont:_detail.billContent||'',
					voice:arrs[0],
					image:arrs[1],
					video:arrs[2]
				}),$elem = $pop.elem;
				$pop.show();
				$elem.find('.b-fold').bind('click',function(){
					$pop.hide();
				});
			});
		},
		showeval:function(){
			var evaLevel = parseInt(_detail.evaLevel);
			var $eval = $($f.page.text('showeval')).appendTo($btns);
			for(var i=1;i<=evaLevel;i++){
				$eval.find('i').eq(i-1).addClass('sel');
			}
		},
		delete:function(){//删除
			var btn = {text:'删除', cls:'c3'},$btn = $($f.page.button(btn)).appendTo($btns).find('button');
			$btn.bind('click',function(e){
				e.preventDefault();
				e.stopPropagation();
				if(_flag)return;
				_flag = true;
				var $load = $f.pop.load().show();
				$f.ajax({
					url:PG.path('delBill'),
					option:{
						userId:userId,
						billId:billId
					},
					success:function(json){
						if(json.result=='0'){
							$f.pop.tip(json.msg).show(function(){
								// PG.close();
								PG.back(PG.href('order.html',{userId:userId}),ture);
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
				})
				return false;
			})
		},
		eval:function(){//评价
			var btn = {text:'评价', cls:'c4'},$btn = $($f.page.button(btn)).appendTo($btns).find('button');
			var $eval = $($f.page.text('eval')).insertBefore($btn.parents('.form-group'));
			var $ebtn = $eval.find('i');
			var index = 0;
			$ebtn.bind('click touchstart',function(){
				var index = $ebtn.index(this)+1;
				$ebtn.removeClass('sel');
				for(var j=0;j<index;j++){
					$ebtn.eq(j).addClass('sel');
				}
			});
			$btn.bind('click',function(e){
				e.preventDefault();
				e.stopPropagation();
				if(_flag)return;
				_flag = true;
				var $load = $f.pop.load().show();
				$f.ajax({
					url:PG.path('evalBill'),
					option:{
						userId:userId,
						billId:billId,
						evaLevel:index+''
					},
					success:function(json){
						if(json.result=='0'){
							$f.pop.tip(json.msg).show(function(){
								// PG.close();
								PG.back(PG.href('order.html',{userId:userId}),true);
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
				})
				return false;
			})
		},
		stop:function(){//中止
			var btn = {text:'中止', cls:'c2'},$btn = $($f.page.button(btn)).appendTo($btns).find('button');
			$btn.bind('click',function(e){
				e.preventDefault();
				e.stopPropagation();
				if(_flag)return;
				_flag = true;
				var $pop = $f.pop.stop(),$elem = $pop.elem;
				$pop.show();
				$elem.find('.b-cancel').bind('click', function(event) {
					$pop.hide();
				});
				$elem.find('.b-confirm').bind('click',function(event){
					var $rd = $elem.find('input[name="optionsRadios"]:checked');
					if(!$rd.length){
						$f.pop.tip('请选择原因').show();
					}else{
						var val = $rd.next('span').text();
						$pop.hide();
						var $load = $f.pop.load().show();
						$f.ajax({
							url:PG.path('stopBill'),
							option:{
								userId:userId,
								billId:billId,
								reason:val
							},
							success:function(json){
								if(json.result=='0'){
									$f.pop.tip(json.msg).show(function(){
										// PG.close();
										PG.back(PG.href('order.html',{userId:userId}),true);
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
					}
				});
				$elem.one('hide',function(){
					_flag = false;
				});
			});

		},
		cancel:function(){//撤回
			var btn = {text:'撤回', cls:'c1'},$btn = $($f.page.button(btn)).appendTo($btns).find('button');
			$btn.bind('click',function(e){
				e.preventDefault();
				e.stopPropagation();
				if(_flag)return;
				_flag = true;
				var $pop = $f.pop.cancel(),$elem = $pop.elem;
				$pop.show();
				$elem.find('.b-cancel').bind('click', function(event) {
					$pop.hide();
				});
				$elem.find('.b-confirm').bind('click',function(event){
					var $rd = $elem.find('textarea');
					if(!$rd.val()){
						$f.pop.tip('请填写原因').show();
					}else{
						var val = $rd.val();
						$pop.hide();
						var $load = $f.pop.load().show();
						$f.ajax({
							url:PG.path('cancelBill'),
							option:{
								userId:userId,
								billId:billId,
								reason:val
							},
							success:function(json){
								if(json.result=='0'){
									$f.pop.tip(json.msg).show(function(){
										// PG.close();
										PG.back(-1,true);
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
					}
				});
				$elem.one('hide',function(){
					_flag = false;
				});
			});
		},
		edit:function(){//编辑
			var btn = {text:'编辑', cls:'c2'},$btn = $($f.page.button(btn)).appendTo($btns).find('button');
			$btn.bind('click',function(e){
				e.preventDefault();
				e.stopPropagation();
				$f.db.set('detail',_detail);
				PG.open(PG.href('create.html',{
					userId:userId,
					edit : 1
				}));
				return false;
			});
		}
	},
	btnInit:function(){
		var _ = this;
		$('body').on('click','.ad',function(){
			var src = $(this).data('src');
			if(!src)return;
			var ad = PG.native.media(src);
			ad.play();
			$('body').one('touchstart',function(){
				ad.stop();
				ad = null;
			});
		});
		$('body').on('click touchstart','.img',function(){
			var src = $(this).data('src');
			if(!src)return;
			var $pop = $f.pop.resource().show();
			var $load = $f.pop.load().show();
			var _img = new Image();
			_img.onload = function(){
				$load&&$load.hide();
				$pop&&$pop.bg(src);
			};
			var _unload = function(){
				$load&&$load.hide();
				$pop&&$pop.hide();
			};
			_img.unload = function(){
				_unload();
			};
			_img.src = src;
			$('body').one('touchstart',function(){
				_unload();
			});
		});

		$('body').on('click touchstart','.vd',function(){
			var src = $(this).data('src');
			if(!src)return;
			var $pop = $f.pop.resource().show();
			$pop.video(src);
			var $v = $pop.elem.find('video');
			$v.bind('ended error pause',function(){
				$v.css({'visibility':'hidden'}).remove();
				_unload();
			});
			$v[0].play();
			var _unload = function(){
				$pop&&$pop.hide();
			};
		});
	}
};

$(function(){
	$f.req.user(function(){
		var $load = $f.pop.load().show();
		$.when($f.req.channel(),$f.req.type()).always(function(){
			Page.init();
			$load.hide();
		});
	});
})

}(jQuery);