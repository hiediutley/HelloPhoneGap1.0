//from Jesse McFayden, Nitobi Inc
//https://gist.github.com/raw/476358/dae649dc8d7b20041780bc6a2bcfcb9f31dbcdfe/pgDebug.js
var safariDebug = (navigator.platform.indexOf("iPhone") < 0 && navigator.platform.indexOf("iPod") < 0 && navigator.platform.indexOf("iPad") < 0);

if (safariDebug)
{

    PhoneGap.run_command = function()
    {
        if (!PhoneGap.available || !PhoneGap.queue.ready)
		{
			return;
		}

        PhoneGap.queue.ready = false;

        var args = PhoneGap.queue.commands.shift();
        if (PhoneGap.queue.commands.length == 0) {
            clearInterval(PhoneGap.queue.timer);
            PhoneGap.queue.timer = null;
        }

        var uri = [];
        var dict = null;
        for (var i = 1; i < args.length; i++) {
            var arg = args[i];
            if (arg == undefined || arg == null)
            	arg = '';
            if (typeof(arg) == 'object')
            	dict = arg;
            else
            	uri.push(encodeURIComponent(arg));
        }
        var url = "gap://" + args[0] + "/" + uri.join("/");
        if (dict != null) {
            var query_args = [];
            for (var name in dict) {
                if (typeof(name) != 'string')
                continue;
                query_args.push(encodeURIComponent(name) + "=" + encodeURIComponent(dict[name]));
            }
            if (query_args.length > 0)
            url += "?" + query_args.join("&");
        }
        alert(url);
        //console.log(url);
        setTimeout(function() {
            PhoneGap.queue.ready = true;
        },
        10);
        // so the next one can go
    };

	setTimeout(function() {
	    DeviceInfo.uuid = "testing";
	},
	2000);
    
    alert("here2");
}

