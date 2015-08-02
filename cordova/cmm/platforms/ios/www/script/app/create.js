!function($){

var $order = $('.orders');
var userId , userInfo ,type , channels , detail ;
var voice = [],image = [],video = [],channel = [],channelArr = [];
var Page = {
	init : function(){
		var _ = this;
		userId = $f.db.get('userId');
		userInfo = $f.db.get('userInfo');
		type = $f.db.get('type');
		channels = $f.db.get('channel');
		_.cssInit();
		_.pageInit();
		_.btnInit();
		_.editInit();
	},
	editInit:function(){
		var _ = this;
		var _url = $f.api.urlparam();
		if(_url.edit == '1'){
			detail = $f.db.get('detail');
			// $f.db.remove('detail');
			voice = !!detail.voice?detail.voice.split(','):[],
			image = !!detail.image?detail.image.split(','):[],
			video = !!detail.video?detail.video.split(','):[];
			$('.inp-title').val(detail.billTitle);
			$('.select-type option[value="'+detail.billType+'"]').attr("selected", "selected");
			$('input[name="relateChannel"]').filter('[value='+detail.relateChannel+']')[0].checked = true;
			$('.inp-work').val(detail.billContent);
			if(detail.relateChannel=='2'){
				var $channels = $('.form-channels').show();
				channel = $f.isArray(detail.relateChannelIds)?detail.relateChannelIds:[];
				$.each(channel,function(index, el) {
					channel[index] = parseInt(el);
				});
				$.each(channel,function(index,id){
					var flag = false;
					for(var i=0;i<channels.length;i++){
						if(!flag&&id==channels[i].id){
							channelArr.push(channels[i]);
							flag = true;
						}
					}
				});
				$.each(channelArr,function(index,val){
					var str = $f.TPL(TPL.cldiv,{
						unitnum : val.unitnum,
						unitname : val.unitname
					});
					$(str).insertBefore($channels.find('.col-btn'));
				});
			}

			if(voice.length>0){
				var $audios = $('.audios'),
				$tipaudio = $audios.find('.tip'),
				tpl_audio = '<div class="audio-item"><a href="javascript:void(0);" data-src="{src}" class="b b-audio ad"></a> </div>';
				$.each(voice,function(index, src) {
					var $v = $($f.TPL(tpl_audio,{src:PG.resource()+src})).appendTo($audios.find('.audio-wrap'));
				});
				$tipaudio.html(_.tip(voice,PG.RS.voice));
	    		if(voice.length==1){
	    			$audios.show();
	    		};
	    		if(voice.length>=PG.RS.voice){
	    			$('.b-rec').unbind('click').hide();
	    		}
			}
			if(image.length>0){
				var $images = $('.form-images'),
				$colimage = $images.find('.col-btn'),
				$tipimage = $images.find('.tip'),
				tpl_image = '<div class="col-xs-3"><div class="img" data-src="{src}" style="background-image:url({src})"></div></div>';

				$.each(image,function(index, src) {
					var $img = $($f.TPL(tpl_image,{src:PG.resource()+src})).insertBefore($colimage);
				});
        		$tipimage.html(_.tip(image,PG.RS.image));
        		if(image.length>=PG.RS.image){
        			$('.b-image').unbind('click');
        			$colimage.hide();
        		}
			}

			if(video.length>0){
				var $videos = $('.form-videos'),
				$colvideo = $videos.find('.col-btn'),
				$tipvideo = $videos.find('.tip'),
				tpl_video = '<div class="col-xs-3"><div class="vd" data-src="{src}"></div></div>';

				$.each(video,function(index, src) {
					var $vd = $($f.TPL(tpl_video,{src:PG.playpath()+src})).insertBefore($colvideo);
				});
        		$tipvideo.html(_.tip(video,PG.RS.video));

        		if(video.length>=PG.RS.video){
        			$('.b-video').unbind('click');
        			$colvideo.hide();
        		}
			}
			
		};
	},
	cssInit:function(){
		var _ = this;
		$.each(type, function(index, val) {
			 $('.select-type').append($f.TPL(TPL.option,{key:val.id,value:val.titile}));
		});

		var _state = false,$load;

		var $audios = $('.audios'),
			$tipaudio = $audios.find('.tip'),
			tpl_audio = '<div class="audio-item"><div href="javascript:void(0);" data-src="{src}" class="b b-audio ad"></div> </div>';
		
		$tipaudio.html(_.tip(voice,PG.RS.voice));
		$('.b-rec').bind('click',function(){
			if(_state)return;
			_state = true;
			$load = $f.pop.load();
			$load.show();
			PG.native.audio(function(mediaFiles){
				for (var i = 0, len = mediaFiles.length; i < len; i += 1) {
		            var ft = _.upload(mediaFiles[i],function(r){
		            	// log(r);
		            	// alert(JSON.stringify(r));
		            	var json = $f.isObject(r.response)?r.response:JSON.parse(r.response);
		            	if(json&&json.result=='0'){
		            		voice.push(json.data);
		            		var $v = $($f.TPL(tpl_audio,{src:PG.resource()+json.data})).appendTo($audios.find('.audio-wrap'));
		            		$tipaudio.html(_.tip(voice,PG.RS.voice));

		            		if(voice.length==1){
		            			$audios.show();
		            		};
		            		if(voice.length>=PG.RS.voice){
		            			$('.b-rec').unbind('click').hide();
		            		}
		            	}
		            	reset($load);
		            },function(){
		            	reset($load);
		            },{
		            	userId:userId
		            });
		            abort(ft,$load);
		        }
		        if(!mediaFiles||mediaFiles.length==0){
		        	reset($load);
		        }
			},function(){
				reset($load);
			});
		});
		
		//http://123.57.45.235:8090/fz_yxjl/downloadFullPath?fullPath=1434154265285_-1488275431.jpg
		var $images = $('.form-images'),
			$colimage = $images.find('.col-btn'),
			$tipimage = $images.find('.tip'),
			tpl_image = '<div class="col-xs-3"><div class="img" data-src="{src}" style="background-image:url({src})"></div></div>';

		$tipimage.html(_.tip(image,PG.RS.image));
		$('.b-image').bind('click',function(){
			var opt = {mediaType:0 , destinationType: 1,sourceType : 1};
			if(!$images.find('.HDimg').prop("checked")){
				opt.quality = 50;
				opt.targetWidth = 960;
				opt.targetHeight = 1280;
			}
			/*
				
				Camera.DestinationType = {
			        DATA_URL : 0,                // Return image as base64 encoded string
			        FILE_URI : 1                 // Return image file URI
			    };
				Camera.PictureSourceType = {
				    PHOTOLIBRARY : 0,
				    CAMERA : 1,
				    SAVEDPHOTOALBUM : 2
				};
			*/
			var confirm = $f.pop.confirm(
					{tip:'选择图片',confirm:'相册',cancel:'拍照'},
					function(){
						opt.sourceType = 0;
						_handle();
					},
					function(){
						_handle();
					},
					true,function(){}
				).show();
			var _handle = function(){
				if(_state)return;
				_state = true;
				$load = $f.pop.load();
				$load.show();
				PG.native.camera(
					function(imageURI){
						if(!imageURI){
							reset($load);
							return false;
						};
						var mediaFile = {
							fullPath : imageURI,
						    type : "image/jpeg"
						};
						// alert('imageURI:'+imageURI);
			            var ft = _.upload(mediaFile,function(r){
			            	// log(r);
			            	// alert(JSON.stringify(r));
			            	var json = $f.isObject(r.response)?r.response:JSON.parse(r.response);
			            	if(json&&json.result=='0'){
			            		image.push(json.data);
			            		var $img = $($f.TPL(tpl_image,{src:PG.resource()+json.data})).insertBefore($colimage);
			            		$tipimage.html(_.tip(image,PG.RS.image));

			            		if(image.length>=PG.RS.image){
			            			$('.b-image').unbind('click');
			            			$colimage.hide();
			            		}
			            	}
			            	reset($load);
			            },function(){
			            	reset($load);
			            	$f.pop.tip('上传失败,请稍后尝试!',null,true).show();
			            },{
			            	userId:userId
			            },'camera.jpg');
			            abort(ft,$load);
					},
					function(){
						reset($load);
					},
					opt
				);
			}
			/**/
			/*PG.native.image(function(mediaFiles){
				for (var i = 0, len = mediaFiles.length; i < len; i += 1) {
		            _.upload(mediaFiles[i],function(r){
		            	// log(r);
		            	var json = $f.isObject(r.response)?r.response:JSON.parse(r.response);
		            	if(json&&json.result=='0'){
		            		image.push(json.data);
		            		var $img = $($f.TPL(tpl_image,{src:PG.resource()+json.data})).insertBefore($colimage);
		            		$tipimage.html(_.tip(image,PG.RS.image));

		            		if(image.length>=PG.RS.image){
		            			$('.b-image').unbind('click');
		            			$colimage.hide();
		            		}
		            	}
		            	reset($load);
		            },function(){
		            	reset($load);
		            },{
		            	userId:userId
		            });
		        }
		        if(!mediaFiles||mediaFiles.length==0){
		        	reset($load);
		        }
			},function(){
				reset($load);
			});*/
		});
		
		var $videos = $('.form-videos'),
			$colvideo = $videos.find('.col-btn'),
			$tipvideo = $videos.find('.tip'),
			tpl_video = '<div class="col-xs-3"><div class="vd" data-src="{src}"></div></div>';

		$tipvideo.html(_.tip(video,PG.RS.video));
		$('.b-video').bind('click',function(){
			if(_state)return;
			_state = true;
			$load = $f.pop.load();
			$load.show();
			PG.native.video(function(mediaFiles){
				 for (var i = 0, len = mediaFiles.length; i < len; i += 1) {
		            _.upload(mediaFiles[i],function(r){
		            	// log(r);
		            	var json = $f.isObject(r.response)?r.response:JSON.parse(r.response);
		            	if(json&&json.result=='0'){
		            		video.push(json.data);
		            		var $vd = $($f.TPL(tpl_video,{src:PG.playpath()+json.data})).insertBefore($colvideo);
		            		$tipvideo.html(_.tip(video,PG.RS.video));

		            		if(video.length>=PG.RS.video){
		            			$('.b-video').unbind('click');
		            			$colvideo.hide();
		            		}
		            	}
		            	reset($load);
		            },function(){
		            	reset($load);
		            	$f.pop.tip('上传失败,请稍后尝试!',null,true).show();
		            },{
		            	userId:userId
		            });
		        }
		        if(!mediaFiles||mediaFiles.length==0){
		        	reset($load);
		        }
			},function(){
				reset($load);
			});
		});


		var timer = null,
			stop = function(){
				if(timer){
					clearTimeout(timer);
					timer = null;
				};
			},
			reset = function($load,func){
				stop();
				$load.hide();
				_state = false;
				$f.isFunction(func)&&func();
			},
			abort = function(ft,$load,time){
				time = time || 15000;
				stop();
				var timer = setTimeout(function(){
					if(_state){
						ft.abort();
						reset($load,function(){
							$f.pop.tip('请求超时',null,true).show();
						});
					}
				},time);
			};
	},
	tip : function(type,limit){
		return '<em>'+($f.isArray(type)?type.length:0)+'</em>/'+(limit||0);
	},
	upload:function(file,suc,err,param,fileName){
		return PG.native.upload(file,suc,err,param,fileName);
	},
	pageInit:function(){
		var _ = this;

		$('.b-back').bind('tap',function(){
			PG.close();
		});
		$('.b-next').bind('click',function(e){
			e.preventDefault();  
			e.stopPropagation(); 

			if(!$('.inp-title').val()){
				$f.pop.tip(PG.info.CreateTitle,1500).show();
				return;
			}

			var rc = $('input[name=relateChannel]:checked').val();
			if(rc=='2'&&channel.length==0){
				$f.pop.tip(PG.info.CreateChannel,1500).show();
				return;
			}

			if(!($('.inp-work').val() || video.length||image.length||voice.length)){
				$f.pop.tip(PG.info.CreateText,1500).show();
				return;
			};
			
			$f.db.set('save',$.extend({
				userId:userId,
				video:video.join(','),
				voice:voice.join(','),
				image:image.join(','),
				relateChannelIds:rc=='1'?'':channel.join(','),
				billContent:$('.inp-work').val(),
				relateChannel:rc,
				billTitle:$('.inp-title').val(),
				billType: $('.select-type').val(),
				createTime : new Date().format('yyyy-MM-dd hh:mm:ss'),
			},!!detail?{
				createTime:detail.createTimeString,
				id:detail.id
			}:undefined));
			PG.open(PG.href('save.html',{userId:userId}));
			return false;
		});
	},
	btnInit:function(){
		var _ = this;
		var $audios = $('.audios'),
			$tipaudio = $audios.find('.tip');
		$('body').on('tap','.ad',function(){
			var src = $(this).data('src');
			if(!src)return;
			var ad = PG.native.media(src);
			ad.play();
			$('body').one('touchstart',function(){
				ad.stop();
				ad = null;
			});
		}).on('press','.ad',function(){
			var _this = this;
			var index = $('.ad').index(this);
			$f.pop.confirm('确定删除该录音？',function(){
				voice.splice(index,1);
				$(_this).parents('.audio-item').remove();
				if(voice.length==0){
					$audios.hide();
				}
				$tipaudio.html(_.tip(voice,PG.RS.voice));
			}).show();
		});

		var $images = $('.form-images'),
			$tipimage = $images.find('.tip');
		$('body').on('tap','.img',function(){
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
		}).on('press','.img',function(){
			var _this = this;
			var index = $('.img').index(this);
			$f.pop.confirm('确定删除该图片？',function(){
				image.splice(index,1);
				$(_this).parents('.col-xs-3').remove();
				$tipimage.html(_.tip(image,PG.RS.image));
			}).show();
		});

		var $videos = $('.form-videos'),
			$tipvideo = $videos.find('.tip');
		$('body').on('tap','.vd',function(){
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
		}).on('press','.vd',function(){
			var _this = this;
			var index = $('.vd').index(this);
			$f.pop.confirm('确定删除该视频？',function(){
				video.splice(index,1);
				$(_this).parents('.col-xs-3').remove();
				$tipvideo.html(_.tip(video,PG.RS.video));
			}).show();
		});


		$('.rd-channel').bind('click', function(event) {
			$('.form-channels').show();
		});
		$('.rd-all').bind('click',function(event){
			$('.form-channels').hide();
		});

		var getChannel = function(option){
				var arr = [];
				for(var i =0;i<channels.length;i++){
					if(!option.text||channels[i].unitname.indexOf(option.text)>-1){
						var cl = channels[i];
						if($f.array.indexOf(channel,cl.id)>-1){
							cl.checked = true;
						}else{
							cl.checked = null;
						}
						cl.unittype = PG.unit[cl.unittypeid];
						arr.push(cl);
					}
				}
				return arr.slice(option.page*PG.RS.channelShow,PG.RS.channelShow*(option.page+1));
			},
			renderChannel = function($wrap,option,clear,func){
				var data = getChannel(option);
				if(channels.length<=PG.RS.channelShow*(option.page+1)){
					option.has = false;
				}
				if(clear){$wrap.empty();}
				var $cont = $($f.pop.cl({channel:data})).appendTo($wrap);
				$cont.bind('tap',function(e){
					e.preventDefault();
					e.stopPropagation();
					var _this = this;
					var input = $(this).find('input'),checked = input[0].checked;
					var id = $(this).data('id'),idx = $f.array.indexOf(channel,id);
					if(idx>-1){
						channel.splice(idx,1);
						channelArr.splice(idx,1);
					}else{
						channel.push(id);
						var flag = false;
						for(var i=0;i<channels.length;i++){
							if(!flag&&id==channels[i].id){
								channelArr.push(channels[i]);
								flag = true;
							}
						}
					}
					!checked?(input[0].checked = true):(input[0].checked = false);
					
					var $channels = $('.channels');
					$channels.children().not('.col-btn').remove();
					$.each(channelArr,function(index,val){
						var str = $f.TPL(TPL.cldiv,{
							unitnum : val.unitnum,
							unitname : val.unitname
						});
						$(str).insertBefore($channels.find('.col-btn'));
					});
				})
				$f.isFunction(func)&&func();
				// $scroll.refresh();
			};

		$('.b-channel').bind('tap', function(event) {
			$('.inp').blur();
			var $sc = $f.pop.channel({});
			setTimeout(function(){
				$sc.show(function(){
					var $elem = $sc.elem;
					var $scroll = $f.pop.scroll($sc.elem.find('.body'));
					window.aaa = $scroll;
					var option = {
						page : 0,
						text : '',
						has : true
					};
					// PG.RS.channelShow
					var $body = $elem.find('.body'),$wrap = $body.find('.wrap');

					$body.height($elem.height()-205);
					renderChannel($wrap,option,true,function(){$scroll.refresh();});
					$body.parents('.box').removeClass('loading_2');
					var _state_ = false;
					if(!!option.has){
						$scroll.on('scrollEnd',function(){
							if(!!option.has&&!_state_&&$scroll.y<=$scroll.maxScrollY+100){
								_state_ = true;
								option.page ++;
								renderChannel($wrap,option,false,function(){
									$scroll.refresh();
									_state_ = false;
								});
							}
						});
					};
					$elem.find('.b-tosearch').bind('click',function(){
						option = {
							text :$elem.find('.inp-search').val(),
							page : 0,
							has : true
						};
						_state_ = true;
						renderChannel($wrap,option,true,function(){
							$scroll.refresh();
							_state_ = false;
						});
					});
					$elem.find('.b-confirm').bind('click', function(event) {
						$sc.hide();
					});
				});
			},100);
		});
		/*$('body').on('click','.cl',function(){
			var input = $(this).find('input');
			!input[0].checked?(input[0].checked = true):(input[0].checked = false);
		});*/
	}
};

$(function(){
	$f.req.user(function(){
		var $load = $f.pop.load().show();
		$.when($f.req.type(),$f.req.channel()).always(function(){
			Page.init();
			$load.hide();
		});
	});
});

}(jQuery);