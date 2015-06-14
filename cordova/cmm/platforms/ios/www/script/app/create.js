!function($){

var $order = $('.orders');
var userId , userInfo ,type ;
var voice = [],image = [],video = [];
var Page = {
	init : function(){
		var _ = this;
		userId = $f.db.get('userId');
		userInfo = $f.db.get('userInfo');
		type = $f.db.get('type');
		_.cssInit();
		_.pageInit();
		_.btnInit();
	},
	cssInit:function(){
		var _ = this;
		$.each(type, function(index, val) {
			 $('.select-type').append($f.TPL(TPL.option,{key:val.id,value:val.titile}));
		});

		var _state = false,$load;

		var $audios = $('.audios'),
			$tipaudio = $audios.find('.tip'),
			tpl_audio = '<div class="audio-item"><a href="javascript:void(0);" data-src="{src}" class="b b-audio ad"></a> </div>';
		$tipaudio.html(_.tip(voice,PG.RS.voice));
		$('.b-rec').bind('click',function(){
			if(_state)return;
			_state = true;
			$load = $f.pop.load();
			$load.show();
			PG.native.audio(function(mediaFiles){
				 for (var i = 0, len = mediaFiles.length; i < len; i += 1) {
		            _.upload(mediaFiles[i],function(r){
		            	// log(r);
		            	// alert(JSON.stringify(r));
		            	var json = $f.isObject(r.response)?r.response:JSON.parse(r.response);
		            	if(json&&json.result=='0'){
		            		voice.push(json.data);
		            		var $v = $($f.TPL(tpl_audio,{src:PG.resource+json.data})).appendTo($audios.find('.audio-wrap'));
		            		$tipaudio.html(_.tip(voice,PG.RS.voice));

		            		if(voice.length==1){
		            			$audios.show();
		            		};
		            		if(voice.length>=PG.RS.voice){
		            			$('.b-rec').unbind('click').hide();
		            		}
		            	}else{
		            		reset($load);
		            	}
		            },function(){
		            	reset($load);
		            },{
		            	userId:userId
		            });
		        }
		        if(mediaFiles||mediaFiles.length==0){
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
			if(_state)return;
			_state = true;
			$load = $f.pop.load();
			$load.show();
			PG.native.image(function(mediaFiles){
				 for (var i = 0, len = mediaFiles.length; i < len; i += 1) {
		            _.upload(mediaFiles[i],function(r){
		            	// log(r);
		            	var json = $f.isObject(r.response)?r.response:JSON.parse(r.response);
		            	if(json&&json.result=='0'){
		            		image.push(json.data);
		            		var $img = $($f.TPL(tpl_image,{src:PG.resource+json.data})).insertBefore($colimage);
		            		$tipimage.html(_.tip(image,PG.RS.image));

		            		if(image.length>=PG.RS.image){
		            			$('.b-image').unbind('click');
		            			$colimage.hide();
		            		}
		            	}else{
		            		reset($load);
		            	}
		            },function(){
		            	reset($load);
		            },{
		            	userId:userId
		            });
		        }
		        if(mediaFiles||mediaFiles.length==0){
		        	reset($load);
		        }
			},function(){
				reset($load);
			});
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
		            	var json = $f.isObject(r.response)?r.response:JSON.parse(r.response);
		            	if(json&&json.result=='0'){
		            		video.push(json.data);
		            		var $vd = $($f.TPL(tpl_video,{src:PG.resource+json.data})).insertBefore($colvideo);
		            		$tipvideo.html(_.tip(video,PG.RS.video));

		            		if(video.length>=PG.RS.video){
		            			$('.b-video').unbind('click');
		            			$colvideo.hide();
		            		}
		            	}else{
		            		reset($load);
		            	}
		            },function(){
		            	reset($load);
		            },{
		            	userId:userId
		            });
		        }
		        if(mediaFiles||mediaFiles.length==0){
		        	reset($load);
		        }
			},function(){
				reset($load);
			});
		});


		var reset = function($load,func){
			$load.hide();
			_state = false;
			$f.isFunction(func)&&func();
		}
	},
	tip : function(type,limit){
		return '<em>'+($f.isArray(type)?type.length:0)+'</em>/'+(limit||0);
	},
	upload:function(file,suc,err,param){
		PG.native.upload(file,suc,err,param);
	},
	pageInit:function(){
		var _ = this;

		$('.b-back').bind('touchstart click',function(){
			PG.close();
		});
		$('.b-next').bind('touchstart click',function(e){
			e.preventDefault();  
			e.stopPropagation(); 
			$f.db.set('save',{
				userId:userId,
				video:video.join(','),
				voice:voice.join(','),
				image:voice.join(','),
				billContent:$('.inp-work').val(),
				relateChannel:$('input[name=relateChannel]:checked').val(),
				billTitle:$('.inp-title').val(),
				billType: $('.select-type').val(),
				createTime : new Date().format('yyyy-MM-dd hh:mm:ss')
			});
			PG.open(PG.href('save.html',{userId:userId}));
			return false;
		});
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
		$f.req.type().always(function(){
			Page.init();
		})
	});
})

}(jQuery);