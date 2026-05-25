import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

// Entry point — registered in manifest.xml as `entry="StealthWealthApp"`
class StealthWealthApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function getInitialView() as [WatchUi.Views] or [WatchUi.Views, WatchUi.InputDelegates] {
        return [new StealthWealthView()];
    }
}

function getApp() as StealthWealthApp {
    return Application.getApp() as StealthWealthApp;
}
