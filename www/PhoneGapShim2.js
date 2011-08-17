function StopGap() {
    function deviceready() {
        // fire off deviceready
        var e = document.createEvent('Events'); 
        e.initEvent('deviceready');
        document.dispatchEvent(e);
    }
    
    window.PhoneGap = {};
    deviceready();
}
