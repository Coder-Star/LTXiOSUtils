var bridge = {
	// 为typescript使用
    default:this,
    
	/** 调用原生方法
	 * @param {Object} method 原生方法名
	 * @param {Object} args 参数
	 * @param {Object} cb 异步方法回调函数
	 */
	call: function (method, args, cb) {
        var ret = '';
        
		if (typeof args == 'function') {
            cb = args;
            args = {};
        }
        
		var arg={data:args===undefined?null:args}
        
		// js调用原生异步方法，将js端异步回调注册成全局函数，原生端组成调用JS的队列，每50毫秒调用一下这个全局函数
        // 之所以使用消息队列的原因是为了不频繁调用JS，防止JS卡死
		if (typeof cb == 'function') {
            var cbName = 'dscb' + window.dscb++;
            window[cbName] = cb;
			// 异步id，原生调用js时，根据该id找到对应的全局函数
            arg['_dscbstub'] = cbName;
        }
        
		arg = JSON.stringify(arg)

		// 供高版本Android使用，使用addJavascriptInterface的形式
        if(window._dsbridge){
           ret=  _dsbridge.call(method, arg)
        }else if(window._dswk||navigator.userAgent.indexOf("_dsbridge")!=-1){
			// window._dswk 给 iOS 使用, iOS端在Webview启动的时候会执行js代码，将window._dswk设为true
			// navigator.userAgent.indexOf("_dsbridge") 给低版本SDKAndroid使用
			// 使用prompt弹出输入框，阻塞js
           ret = prompt("_dsbridge=" + method, arg);
        }

       return  JSON.parse(ret||'{}').data
    },
    
	/** js端注册方法，供原生调用
	 * @param {Object} name 方法名
	 * @param {Object} fun 参数
	 * @param {Object} asyn 是否异步
	 */
	register: function (name, fun, asyn) {
		// 判断是否异步，选择不同的数据结构
        var q = asyn ? window._dsaf : window._dsf
        
		// 只调用一次，为的是调用一次native的dsinit方法
		// 用来保证原生部分Webview还未初始化完成时，js调用原生也可以等到初始化完成后进行响应
		if (!window._dsInit) {
            window._dsInit = true;
            setTimeout(function () {
                bridge.call("_dsb.dsinit");
            }, 0)
        }
        
		if (typeof fun == "object") {
			// 判断a是否是一个对象，以此判断是否内部具有多个方法，并将回调保存到对应位置
			// 方便js端函数可以注册成命名空间的形式
            q._obs[name] = fun;
        } else {
            q[name] = fun
        }
    },
    
	// 注册异步方法
	registerAsyn: function (name, fun) {
        this.register(name, fun, true);
    },
    
	
	// 判断是否有原生方法
	hasNativeMethod: function (name, type) {
        return this.call("_dsb.hasNativeMethod", {name: name, type:type||"all"});
    },
    
	// 禁止捕获alert、confirm、prompt等弹出框
	disableJavascriptDialogBlock: function (disable) {
        this.call("_dsb.disableJavascriptDialogBlock", {
            disable: disable !== false
        })
    }
};

!function () {
    
	if (window._dsf) return;
    
	var ob = {
        // 存储同步
		_dsf: {
			// 存储多个js方法，命名空间方式
            _obs: {}
        },
		// 存储异步
		_dsaf: {
            _obs: {}
        },
        
		// 计数标识，用来标识js调用原生异步方法 js端回调函数的id
		dscb: 0,
        
		dsBridge: bridge,
        
		// 关闭，原生端内部实现
		close: function () {
            bridge.call("_dsb.closePage")
        },
        
		/** 监听从原生传来的信息
		 * @param {Object} info 包括 method、callbackId、data
		 */
		_handleMessageFromNative: function (info) {
            var arg = JSON.parse(info.data);

            // callbackId为原生端回调函数的id，原生端使用字典为id与回调函数闭包提供映射关系
			var ret = {
                id: info.callbackId,
                complete: true
            }
            
			// 同步方法
			var f = this._dsf[info.method];
            
			// 异步方法
			var af = this._dsaf[info.method]
            
			var callSyn = function (f, ob) {
                ret.data = f.apply(ob, arg)
                bridge.call("_dsb.returnValue", ret)
            }
            
			var callAsyn = function (f, ob) {
                arg.push(function (data, complete) {
                    ret.data = data;
                    ret.complete = complete!==false;
                    bridge.call("_dsb.returnValue", ret)
                })
                f.apply(ob, arg)
            }
            
			if (f) {
                callSyn(f, this._dsf);
            } else if (af) {
                callAsyn(af, this._dsaf);
            } else {
                var name = info.method.split('.');
                if (name.length<2) return;
                var method=name.pop();
                var namespace=name.join('.')
                var obs = this._dsf._obs;
                var ob = obs[namespace] || {};
                var m = ob[method];
                if (m && typeof m == "function") {
                    callSyn(m, ob);
                    return;
                }
                obs = this._dsaf._obs;
                ob = obs[namespace] || {};
                m = ob[method];
                if (m && typeof m == "function") {
                    callAsyn(m, ob);
                    return;
                }
            }
        }
    }
    
	// 将所有方法注册到window
	for (var attr in ob) {
        window[attr] = ob[attr]
    }
    
	// 注册判断是否有js方法
	bridge.register("_hasJavascriptMethod", function (method, tag) {
         var name = method.split('.')
         if(name.length<2) {
           return !!(_dsf[name]||_dsaf[name])
         }else{
           // with namespace
           var method=name.pop()
           var namespace=name.join('.')
           var ob=_dsf._obs[namespace]||_dsaf._obs[namespace]
           return ob&&!!ob[method]
         }
    })
	
}();

module.exports = bridge;
