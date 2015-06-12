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
        },
    cssInit:function(){
        var _ = this;
        $.each(type, function(index, val) {
               $('.select-type').append($f.TPL(TPL.option,{key:val.id,value:val.titile}));
               });
        
        var _state = false,$load;
        $('.b-rec').bind('click',function(){
                         if(_state)return;
                         _state = true;
                         $load = $f.pop.load();
                         $load.show();
                         PG.native.audio(function(mediaFiles){
                                         alert('create.js:'+JSON.stringify(mediaFiles));
                                         for (var i = 0, len = mediaFiles.length; i < len; i += 1) {
                                         _.upload(mediaFiles[i],function(r){
                                                  // log(r);
                                                  alert('success:'+JSON.stringify(r));
                                                  },function(){
                                                  alert('error:'+JSON.stringify(arguments))
                                                  //reset($load);
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
        
        $('.b-image').bind('click',function(){
                           if(_state)return;
                           _state = true;
                           $load = $f.pop.load();
                           $load.show();
                           PG.native.image(function(mediaFiles){
                                           for (var i = 0, len = mediaFiles.length; i < len; i += 1) {
                                           _.upload(mediaFiles[i],function(r){
                                                    // log(r);
                                                    alert(JSON.stringify(r));
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
        
        $('.b-video').bind('click',function(){
                           if(_state)return;
                           _state = true;
                           $load = $f.pop.load();
                           $load.show();
                           PG.native.video(function(mediaFiles){
                                           for (var i = 0, len = mediaFiles.length; i < len; i += 1) {
                                           _.upload(mediaFiles[i],function(r){
                                                    // log(r);
                                                    alert(JSON.stringify(r));
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
                          PG.open(
                                  PG.href('save.html',{userId:userId})
                                  );
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