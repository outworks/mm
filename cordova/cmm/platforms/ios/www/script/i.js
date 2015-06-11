!function($){

	/*
		init
	*/
	$f = window.$f || {
		is: function(A, _) {  
            var $ = Object.prototype.toString.call(_).slice(8, -1).toLowerCase();  
            return _ !== undefined && _ !== null && $ === A.toLowerCase()  
        },  
        isFunction : function(o){return this.is('function',o);},  
        isObject : function(o){return this.is('object',o);},  
        isString : function(o){return this.is('string',o);},  
        isArray : function(o){return this.is('array',o);},  
        isBoolean : function(o){return this.is('boolean',o);},  
        isDate : function(o){return this.is('date',o);},  
        isNumber : function(o){return this.is('number',o);},  
        isUndefined : function(o){return o===undefined;},  
        isNull : function(o){return o===null;},  
        isEmptyObject : function(o){if(this.isObject(o)){for(var i in o){return false;}return true;}else{return false;}},  
        isEmptyArray : function(o){return this.isArray(o)&&o.length==0;},  
        isNotEmptyArray : function(o){return this.isArray(o)&&o.length>0;},
        // object
        TPL: function(template, data) {  
            return template.replace(/\{([\w\.]*)\}/g, function(str, key) {  
                var keys = key.split("."),  
                    v = data[keys.shift()];  
                for (var i = 0, l = keys.length; i < l; i++) v = v[keys[i]];
                return (typeof v !== "undefined" && v !== null) ? v : "";  
            });  
        },
        stringify: function(o) {  
            var str = "{";  
            for (var i in o) {  
                str += (i + ":" + (!!this.isObject(o[i])?arguments.callee.call(this,o[i]):!!this.isString(o[i])?"'"+o[i]+"'":o[i])+",");
            };
            str = str.substr(0,str.length-1)+'}';
            return str;  
        },
        encodeObj : function(obj){
            if(!obj)return '';
            if($f.isObject(obj)){
                for(var i in obj){
                    obj[i] = arguments.callee(obj[i]);
                }
            }else if($f.isArray(obj)){
                for(var i=0;i<obj.length;i++){
                    obj[i] = arguments.callee(obj[i]);
                }
            }else{
                obj = encodeURIComponent(obj);
            }
            return obj;
        },
        decodeObj : function(obj){
            if(!obj)return '';
            if($f.isObject(obj)){
                for(var i in obj){
                    obj[i] = arguments.callee(obj[i]);
                }
            }else if($f.isArray(obj)){
                for(var i=0;i<obj.length;i++){
                    obj[i] = arguments.callee(obj[i]);
                }
            }else{
                obj = decodeURIComponent(obj);
            }
            return obj;
        },
        string : {
            startWith:function(str,r){
                var esc = '*.?+$^[](){}|\\/', arr = r.split('');
                for (var i = 0; i < arr.length; i++) {  
                    if (esc.indexOf(arr[i]) > -1) {arr[i] = '\\' + arr[i];}
                };
                var reg=new RegExp("^"+arr.join(''));     
                return reg.test(str);   
            },
            endWith:function(str,r){
                var esc = '*.?+$^[](){}|\\/', arr = r.split('');
                for (var i = 0; i < arr.length; i++) {  
                    if (esc.indexOf(arr[i]) > -1) {arr[i] = '\\' + arr[i]; }
                };
                var reg=new RegExp(arr.join('')+"$");
                return reg.test(str);
            },
            escape : function(str){
                var _escaper = /\\|'|\"|\r|\n|\u2028|\u2029/g;
                var _escapeChar = function(match) {
                    return '\\' + match;
                };
                return !!str?str.replace(_escaper, _escapeChar):str;
            },
            html2Escape : function(html){
                return html.replace(/[<>&"]/g,function(c){return {'<':'&lt;','>':'&gt;','&':'&amp;','"':'&quot;'}[c];});
            },
            escape2Html : function(html){
                var arrEntities={'lt':'<','gt':'>','nbsp':' ','amp':'&','quot':'"'};
                return html.replace(/&(lt|gt|nbsp|amp|quot);/ig,function(all,t){return arrEntities[t];});
            },
            parseJSONP:function(jsonp,returnObject){
                var _s = $.trim(jsonp).replace(/.*(\(.+\)$)/,function(str,$1){return $1.substr(1,$1.length-2)});
                return !!returnObject?JSON.parse(_s):_s;
            }
        },
        object : {
            sizeOf:function(obj){
                var i = 0;
                $.each(obj, function(index, val) {i++; });
                return i;
            },
            indexOf:function(obj,key,flag){
                var i = 0,_i_ = -1;
                if(!!$f.isArray(obj)){flag = true;}
                $.each(obj, function(index, val) {
                    if((!flag&&index==key)||(!!flag&&val==key)){ _i_ = i;}
                    i++;
                });
                return _i_;
            },
            toUrlString:function(obj){
            	var s = '?';
        		$.each(obj, function(index, val) {
        			s+=(index+'='+val+'&');
        		});
        		if(s.length>0){
        			s = s.substr(0,s.length-1);
        		};
            	return s ; 
            }
        },
        array : {
            indexOf : function(arr,obj,start){
                if(!$f.isArray(arr))return -1;
                for (var i = (start || 0), j = arr.length; i < j; i++) {
                    if (arr[i] === obj) {
                        return i;
                    }
                }
                return -1;
            }
        },
        ax:function(tar,option,call,error,complete,type,dataType,jsonpCallback){
            var _ = this;
            //!noCache&&this.isObject(option)&&(option.r = Math.random());
            return $.ajax({
                url:tar,
                data:option,
                type:!type?"POST":type,dataType:!dataType?"json":dataType,
                success:function(json){
                	if(dataType=='text'&&!!jsonpCallback){
                        json = $f.string.parseJSONP(json,true);
                    }
                    var args = Array.prototype.slice.call(arguments);
                    $f.isFunction(call)&&call.apply(this,args);
                },error:error,complete:complete,jsonpCallback:jsonpCallback,cache:false
            });
        },
        ajax:function(tar,opt){
            if($f.isObject(tar)){opt = tar;tar = null;}
            return this.ax(tar||opt.url,opt.option,opt.success,opt.error,opt.complete,opt.type,opt.dataType,opt.jsonpCallback);
        }
	};

	$f.api = {
		urlparam:function(nodecode){
            var paramstr = (_=document.location.search)?_.substr(1):"",
                arr = paramstr.split('&'),
                obj = {};
            return !nodecode?$f.decodeObj(this.serializeObject(paramstr)):this.serializeObject(paramstr);
        },
        serializeObject:function(str){
            if(!str){return {}};
            var arr,obj = {};
            if($f.isArray(str)){
                arr = [];
                for(var i=0;i<str.length;i++){
                    arr.push(str[i].name+'='+str[i].value);
                }
            }else{
                arr = str.split('&');
            }
            for(var i=0;i<arr.length;i++){
                var _a = arr[i].split('=');
                obj[_a[0]]?($f.isArray(obj[_a[0]])?(obj[_a[0]].push(_a[1])):(obj[_a[0]]=obj[_a[0]].match(/.+/g),obj[_a[0]].push(_a[1]))):(obj[_a[0]]=_a[1]);
            }
            return obj;
        }
	}
	/*
		template
	*/
    $f.templateSettings = {
        evaluate: /<%([\s\S]+?)%>/g,
        interpolate: /<%=([\s\S]+?)%>/g,
        escape: /<%-([\s\S]+?)%>/g
    };

    // When customizing `templateSettings`, if you don't want to define an
    // interpolation, evaluation or escaping regex, we need one that is
    // guaranteed not to match.
    var noMatch = /(.)^/;

    // Certain characters need to be escaped so that they can be put into a
    // string literal.
    var escapes = {
        "'": "'",
        '\\': '\\',
        '\r': 'r',
        '\n': 'n',
        '\u2028': 'u2028',
        '\u2029': 'u2029'
    };

    var escaper = /\\|'|\r|\n|\u2028|\u2029/g;

    var escapeChar = function(match) {
        return '\\' + escapes[match];
    };

    // JavaScript micro-templating, similar to John Resig's implementation.
    // Underscore templating handles arbitrary delimiters, preserves whitespace,
    // and correctly escapes quotes within interpolated code.
    // NB: `oldSettings` only exists for backwards compatibility.
    $f.template = function(text, contexts ,settings, oldSettings) {
        if (!settings && oldSettings) settings = oldSettings;
        settings = $.extend({}, settings, $f.templateSettings);

        // Combine delimiters into one regular expression via alternation.
        var matcher = RegExp([
            (settings.escape || noMatch).source, (settings.interpolate || noMatch).source, (settings.evaluate || noMatch).source
        ].join('|') + '|$', 'g');

        // Compile the template source, escaping string literals appropriately.
        var index = 0;
        var source = "__p+='";
        text.replace(matcher, function(match, escape, interpolate, evaluate, offset) {
            source += text.slice(index, offset).replace(escaper, escapeChar);
            index = offset + match.length;

            if (escape) {
                source += "'+\n((__t=(" + escape + "))==null?'':_.escape(__t))+\n'";
            } else if (interpolate) {
                source += "'+\n((__t=(" + interpolate + "))==null?'':__t)+\n'";
            } else if (evaluate) {
                source += "';\n" + evaluate + "\n__p+='";
            }

            // Adobe VMs need the match returned to produce the correct offest.
            return match;
        });
        source += "';\n";

        // If a variable is not specified, place data values in local scope.
        if (!settings.variable) source = 'with(obj||{}){\n' + source + '}\n';

        source = "var __t,__p='',__j=Array.prototype.join," +
            "print=function(){__p+=__j.call(arguments,'');};\n" +
            source + 'return __p;\n';

        //add
        var _params = [],_contexts = [];
        contexts = contexts || {};
        !contexts['$f']&&(contexts['$f'] = $f);
        for(var i in contexts){
            _params.push(i),_contexts.push(contexts[i]);
        }
        _params.splice(0,0,settings.variable || 'obj');
        _params.push(source);
        

        try {
            // add
            //var render = new Function(settings.variable || 'obj', '_', source);
            var render = Function.apply(this,_params);
        } catch (e) {
            e.source = source;
            throw e;
        }

        var template = function(data) {
            // add
            //return render.call(this, data, $);
            var __contexts = $.merge([data],_contexts);
            return render.apply(this,__contexts);
        };

        // Provide the compiled source as a convenience for precompilation.
        var argument = settings.variable || 'obj';
        template.source = 'function(' + argument + '){\n' + source + '}';

        return template;
    };

    /*
		cookie
    */
    $f.cookie = (function(){
        var cookie = {
            s: function(objName, objValue, objHours, options) {
                var str = objName + "=" + escape(objValue);
                objHours = objHours || 7*24;
                options = options || {};
                if (objHours > 0) {
                    var date = new Date();
                    var ms = objHours * 3600 * 1000;
                    date.setTime(date.getTime() + ms);
                    str += "; expires=" + date.toGMTString();
                }
                str += [options.path ? '; path=' + (options.path) : '', options.domain ? '; domain=' + (options.domain) : '', options.secure ? '; secure' : ''].join('');
                document.cookie = str;
            },
            g: function(objName) {
                var arrStr = document.cookie.split("; ");
                for (var i = 0; i < arrStr.length; i++) {
                    var temp = arrStr[i].split("=");
                    if (temp[0] == objName) return unescape(temp[1]);
                }
            },
            d: function(name, options) {
                var date = new Date();
                options = options || {};
                date.setTime(date.getTime() - 10000);
                var str = name + "=; expires=" + date.toGMTString();
                str += [options.path ? '; path=' + (options.path) : '', options.domain ? '; domain=' + (options.domain) : '', options.secure ? '; secure' : ''].join('');
                document.cookie = str;
            }
        },options = {
            key:'',value:'',hours:7*24,path:'/',domain:'',secure:''
        };
        return {
            add:function(obj){
                var _=this;
                if(!obj||!obj.key)return false;//||!obj.value
                var _opt = $.extend({},options,obj);
                cookie.s(obj.key,obj.value,_opt.hours,_opt);
                return true;
            },
            remove:function(obj){
                var _=this,flag=false;
                if(!obj||!obj.key)return false;
                var _opt = $.extend({},options,obj);
                if(cookie.g(obj.key)){flag = true;}
                cookie.d(obj.key,_opt);
                return flag;
            },
            get:function(obj){
                var _=this;
                if(!obj||!obj.key)return '';
                return cookie.g(obj.key);
            }
        };
    })();

    if(window.localStorage){
        $f.localStorage = function(){
            var storage = window.localStorage;
            return {
                add:function(obj){
                    storage.setItem(obj.key,obj.value);
                },
                remove:function(obj){
                    storage.removeItem(obj.key)
                },
                get:function(obj){
                    return storage.getItem(obj.key);
                }
            }
        }();
    }
    //IE userdata
    
    $f.db = (function(){
        var _domain = '__METUSERDATA__',
            _db = !window.localStorage?$f.cookie:$f.localStorage,
            DE = function(str,pwd) {
                var prand = "";
                for(var i=0;i<pwd.length;i++){
                    prand += pwd.charCodeAt(i).toString();
                }
                var sPos = Math.floor(prand.length / 5);
                var mult = parseInt(prand.charAt(sPos) + prand.charAt(sPos*2) + prand.charAt(sPos*3) + prand.charAt(sPos*4) + prand.charAt(sPos*5));
                var incr = Math.ceil(pwd.length / 2);
                var modu = Math.pow(2, 31) - 1;
                prand = (mult * prand + incr) % modu+'';
                var last = "";
                for (var i = 0; i < str.length; i++) {
                    var key = prand.charCodeAt(i%prand.length);
                    var text = str.charCodeAt(i) ^ key;
                    last += String.fromCharCode(text);
                }
                return last;
            },
            _get = function(domain){
                domain = domain||_domain;
                var _val = _db.get({key:domain}),_obj;
                try{
                    _obj = !_val?{}:JSON.parse(DE(_val,_domain));
                }catch($$){
                    _obj = {};
                }
                return _obj; 
            },
            _set = function(obj,domain){
                if(!obj)return false;
                domain = domain||_domain;
                if($f.isObject(obj)){
                    obj = JSON.stringify(obj);
                }
                _db.add({key:domain,value:DE(obj,_domain)});//obj
                return true;
            },
            _remove = function(domain){
                domain = domain||_domain;
                _db.remove({key:domain});
            }
        return {
            get:function(key,domain){
                var _obj = _get(domain);
                return key==''?_obj:_obj[key];
            },
            set:function(key,val,domain){
                if(!key)return '';
                var _o = {};
                $f.isObject(key)?(domain = val , _o = key):(_o[key] = val);
                var _obj = $.extend({},_get(domain),_o);
                return _set(_obj,domain);
            },
            remove:function(key,domain){
                if(!key){_remove(domain);return;};
                var _obj = _get(domain),__obj={};
                $.each(_obj, function(index, val) {
                    if(index!=key){__obj[index]=val;}
                });
                return _set(__obj,domain);
            },
            empty:function(domain){
                return _remove(domain);
            }
        }
    }());


Date.prototype.format = function (fmt) { //author: meizz   
    var o = {  
        "M+": this.getMonth() + 1, //月份   
        "d+": this.getDate(), //日   
        "h+": this.getHours(), //小时   
        "m+": this.getMinutes(), //分   
        "s+": this.getSeconds(), //秒   
        "q+": Math.floor((this.getMonth() + 3) / 3), //季度   
        "S": this.getMilliseconds() //毫秒   
    };  
    if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));  
    for (var k in o)  
    if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));  
    return fmt;  
}

}(jQuery);
