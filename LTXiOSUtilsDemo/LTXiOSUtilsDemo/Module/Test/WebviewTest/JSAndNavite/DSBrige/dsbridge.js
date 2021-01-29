/**
 _dsaf 异步
 _dsf 同步

 _obs 
 */

var bridge = {
    default: this,

    // 调用原生方法
    // b为方法名，a为参数，c为结果
    call: function (b, a, c) {
        var e = "";
        "function" == typeof a && (c = a, a = {});
        a = {
            data: void 0 === a ? null : a
        };
        
		//异步
        if ("function" == typeof c) {
            var g = "dscb" + window.dscb++;
            window[g] = c;
            // 异步标志
            a._dscbstub = g
        }
        a = JSON.stringify(a);
        if (window._dsbridge) e = _dsbridge.call(b, a);
        // window._dswk 给 iOS 使用, iOS端在Webview启动的时候会执行js代码，将window._dswk设为true
        // navigator.userAgent.indexOf("_dsbridge")给Android使用
        // 使用prompt弹出输入框，阻塞js
        else if (window._dswk || -1 != navigator.userAgent.indexOf("_dsbridge")) e = prompt("_dsbridge=" + b, a);
        return JSON.parse(e || "{}").data
    },

    // js方法注册，b为方法名，a为参数，c为是否异步
    register: function (b, a, c) {
        // 判断是同步还是异步，将方法放在不同的结构里面
        c = c ? window._dsaf : window._dsf;
        window._dsInit || (window._dsInit = !0, setTimeout(function () {
                //  通知Native JS端注册方法完成，这是原生部分可以将存储的调用JS操作进行执行了
				// 这样是保证JS方法还未注册成功，原生的操作可以等待JS方法注册完毕之后继续执行
                bridge.call("_dsb.dsinit")
            },0)
            );
         // 判断a是否是一个对象，以此判断是否内部具有多个方法
        "object" == typeof a ? c._obs[b] = a : c[b] = a
    },

    // 注册异步方法
    registerAsyn: function (b, a) {
        this.register(b, a, !0)
    },
	
	// 原生端内部实现

    // 判断是否有原生方法
    hasNativeMethod: function (b, a) {
        return this.call("_dsb.hasNativeMethod", {
            name: b,
            type: a || "all"
        })
    },

    // 禁止捕获alert、confirm、prompt等弹出框
    disableJavascriptDialogBlock: function (b) {
        this.call("_dsb.disableJavascriptDialogBlock", {
            disable: !1 !== b
        })
    }
};
! function () {
    if (!window._dsf) {
        var b = {
		        // 存储同步
                _dsf: {
                    // 存储多个js方法，命名空间方式
                    _obs: {}
                },
				// 存储异步
                _dsaf: {
                    _obs: {}
                },
                dscb: 0,
                dsBridge: bridge,
                
				// 关闭，原生端内部实现
				close: function () {
                    bridge.call("_dsb.closePage")
                },
                
				// js定义的方法，供原生端通过callHandler调用
                // 传递的参数包括 method、callbackId、data
                _handleMessageFromNative: function (a) {
					// a包含  method、 data、callbackId
					// 定义数据
                    var e = JSON.parse(a.data),
                        
						b = {
                            id: a.callbackId,
                            // 同步调用，complete传true时，Native端会将相应回调删除
                            complete: !0
                        },
                        
						// 获取js方法
						// 同步方法
                        c = this._dsf[a.method],
						// 异步方法
                        d = this._dsaf[a.method],
                        
						// 同步执行
                        h = function (a, c) {
                            // a为js方法，c为 _dsf， e为原生传递来的数据
                            b.data = a.apply(c, e);
                            bridge.call("_dsb.returnValue", b)
                        },
                        
						// 异步
                        k = function (a, c) {
                            e.push(function (a, c) {
                                b.data = a;
								// 异步调用，动态调整
                                b.complete = !1 !== c;
                                bridge.call("_dsb.returnValue", b)
                            });
                            a.apply(c, e)
                        };
                    
					if (c) h(c, this._dsf);
                    else if (d) k(d, this._dsaf);
                    // 处理命名空间
                    else if (c = a.method.split("."), !(2 > c.length)) {
                        a = c.pop();
                        var c = c.join("."),
                            d = this._dsf._obs,
                            d = d[c] || {},
                            f = d[a];
                        f && "function" == typeof f ? h(f, d) : (d = this._dsaf._obs, d = d[c] || {}, (f = d[a]) && "function" == typeof f && k(f, d))
                    }
                }
            },
            a;
        
		// 将所有方法注册到window
        for (a in b) window[a] = b[a];
        
		// 注册判断是否有js方法
        bridge.register("_hasJavascriptMethod", function (a, b) {
            b = a.split(".");
            if (2 > b.length) return !(!_dsf[b] && !_dsaf[b]);
            a = b.pop();
            b = b.join(".");
            return (b = _dsf._obs[b] || _dsaf._obs[b]) && !!b[a]
        })
    }
}();
