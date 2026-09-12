import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class Segment34App extends Application.AppBase {
    
    var mView;
    
    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    function registerOrUnregisterBackgroundEvent() as Void {
        if (!(System has :ServiceDelegate)) {
            return;
        }

        var enableLocalCgm = Application.Properties.getValue("enableLocalCgm") as Boolean;
        if (enableLocalCgm) {
            if (Background.getTemporalEventRegisteredTime() == null) {
                Background.registerForTemporalEvent(new Time.Duration(5 * 60));
            }
        } else {
            if (Background.getTemporalEventRegisteredTime() != null) {
                Background.deleteTemporalEvent();
            }
        }
    }

    // Return the initial view of your application here
    function getInitialView() {
        mView = new Segment34View();
        var delegate = new Segment34Delegate(mView);

        registerOrUnregisterBackgroundEvent();

        return [mView, delegate];
    }

    function onSettingsChanged() as Void {
        registerOrUnregisterBackgroundEvent();
        mView.onSettingsChanged();
        WatchUi.requestUpdate();
    }

    function getServiceDelegate(){
        return [new CgmServiceDelegate()];
    }

    function onBackgroundData(data) {
        if (data instanceof Dictionary) {
            if (data.get("source").equals("CGM_SERVICE")) {
                Storage.setValue("cgmData", data.get("payload"));
            }
        }
    }
}

function getApp() as Segment34App {
    return Application.getApp() as Segment34App;
}
