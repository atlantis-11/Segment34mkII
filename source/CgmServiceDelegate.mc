import Toybox.System;
import Toybox.Lang;

(:background)
class CgmServiceDelegate extends System.ServiceDelegate {
    function initialize() {
        ServiceDelegate.initialize();
    }

    function onTemporalEvent() {
        makeRequest("http://127.0.0.1:17580/sgv.json?brief_mode=Y&count=1");
    }

    function makeRequest(url) as Void {
        var params = {};

        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_GET,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON
            },
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };

        var responseCallback = method(:onReceive);
        Communications.makeWebRequest(url, params, options, responseCallback);
    }

    function onReceive(responseCode as Number, data as Dictionary) as Void {
        if (responseCode == 200 && data.size() > 0) {
            var payload = {
                "source" => "CGM_SERVICE",
                "payload" => data[0]
            };
            Background.exit(payload);
        } else {
            System.println("Could not retrive CGM data, response code: " + responseCode);
        }
    }
}
