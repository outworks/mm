
var StreamingMedia = {
    playAudio : function (url, options) {
        options = options || {};
        cordova.exec(options.successCallback || null, options.errorCallback || null, "StreamingMedia", "playAudio", [url, options]);
    },
    playVideo : function (url, options) {
        options = options || {};
        cordova.exec(options.successCallback || null, options.errorCallback || null, "StreamingMedia", "playVideo", [url, options]);
    };;
};