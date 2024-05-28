import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
using Toybox.Timer;
using Toybox.StringUtil;
class GarminEUCApp extends Application.AppBase {
  private var view;
  private var delegate;
  var timeOut = 10000;
  var activityRecordingDelay = 3000;
  var usePS;
  // private var updateDelay = 100;
  private var alarmsTimer;

  private var activityRecordingRequired = true;
  private var activityRecordView;

  function initialize() {
    vescData.limitedMemory = System.getSystemStats().totalMemory < 128000;
    AppBase.initialize();
    usePS = AppStorage.getSetting("useProfileSelector");

    alarmsTimer = new Timer.Timer();
  }

  // onStart() is called on application start up
  function onStart(state as Dictionary?) as Void {
    // Sandbox zone

    // end of sandbox
    setGlobalSettings();
    rideStatsInit();
    alarmsTimer.start(method(:onUpdateTimer), vescData.updateDelay, true);
  }

  // onStop() is called when your application is exiting
  function onStop(state as Dictionary?) as Void {
    if (vescData.activityAutorecording == true) {
      if (delegate != null && activityRecordView != null) {
        if (activityRecordView.isSessionRecording()) {
          activityRecordView.stopRecording();
        }
      }
    }
    if (vescData.activityAutosave == true && delegate != null) {
      activityRecordView = delegate.getActivityView();
      if (activityRecordView.isSessionRecording()) {
        activityRecordView.stopRecording();
      }
    }
    delegate.unpair();
  }

  // Return the initial view of your application here
  function getInitialView() {
    view = profileSelector.createPSMenu();
    delegate = profileSelector.createPSDelegate();
    if (!usePS) {
      var profile = AppStorage.getSetting("defaultProfile");
      //System.println(profile);
      delegate.setSettings(profile);
      view = delegate.getView();
      delegate = delegate.getDelegate();
    }

    return [view, delegate];
  }
  // Timer callback for various alarms & update UI
  function onUpdateTimer() {
    // dummyGen();
    //Only starts if no profile selected
    if (vescData.wheelName == null && delegate != null && usePS) {
      timeOut = timeOut - vescData.updateDelay;
      if (timeOut <= 0) {
        var profile = AppStorage.getSetting("defaultProfile");
        delegate.setSettings(profile);
      }
    }

    if (vescData.paired == true && vescData.wheelName != null) {
      // automatic recording ------------------
      // a bit hacky maybe ...
      if (vescData.activityAutorecording == true) {
        if (delegate != null && activityRecordView == null) {
          // System.println("initialize autorecording");
          activityRecordView = delegate.getActivityView();
        }
        if (
          activityRecordView != null &&
          !activityRecordView.isSessionRecording() &&
          activityRecordingRequired == true
        ) {
          //enable sensor first ?
          activityRecordView.enableGPS();
          activityRecordingDelay =
            activityRecordingDelay - vescData.updateDelay;
          //force initialization
          activityRecordView.initialize();
          if (activityRecordingDelay <= 0) {
            //System.println("record");
            activityRecordView.startRecording();
            activityRecordingRequired = false;
          }

          //System.println("autorecord started");
        }
      }
      // -------------------------
      //attributing here to avoid multiple calls
      vescData.correctedSpeed = vescData.getCorrectedSpeed();
      vescData.correctedTotalDistance = vescData.getCorrectedTotalDistance();
      vescData.correctedTripDistance = vescData.getCorrectedTripDistance();
      vescData.DisplayedTemperature = vescData.getTemperature();
      vescData.PWM = vescData.getPWM();
      EUCAlarms.speedAlarmCheck();
      if (delegate.getMenu2Delegate().requestSubLabelsUpdate == true) {
        delegate.getMenu2Delegate().updateSublabels();
      }
      var statsIndex = 0;
      if (rideStats.showAverageMovingSpeedStatistic) {
        rideStats.avgSpeed();
        rideStats.statsArray[statsIndex] =
          "Avg Spd: " + valueRound(vescData.avgMovingSpeed, "%.1f").toString();
        //System.println(rideStats.statsArray[statsIndex]);
        statsIndex++;
      }
      if (rideStats.showTopSpeedStatistic) {
        rideStats.topSpeed();
        rideStats.statsArray[statsIndex] =
          "Top Spd: " + valueRound(vescData.topSpeed, "%.1f").toString();
        //System.println(rideStats.statsArray[statsIndex]);
        statsIndex++;
      }
      if (rideStats.showWatchBatteryConsumptionStatistic) {
        rideStats.watchBatteryUsage();
        rideStats.statsArray[statsIndex] =
          "Wtch btry/h: " +
          valueRound(vescData.watchBatteryUsage, "%.1f").toString();
        //System.println(rideStats.statsArray[statsIndex]);
        statsIndex++;
      }
      if (rideStats.showTotalDistance) {
        rideStats.statsArray[statsIndex] =
          "Tot dist: " +
          valueRound(vescData.correctedTotalDistance, "%.1f").toString();
        //System.println(rideStats.statsArray[statsIndex]);
        statsIndex++;
      }
      if (rideStats.showTripDistance) {
        rideStats.statsArray[statsIndex] =
          "Trip dist: " +
          valueRound(vescData.correctedTripDistance, "%.1f").toString();
        //System.println(rideStats.statsArray[statsIndex]);
        statsIndex++;
      }
      if (rideStats.showVoltage) {
        rideStats.statsArray[statsIndex] =
          "voltage: " + valueRound(vescData.getVoltage(), "%.2f").toString();
        //System.println(rideStats.statsArray[statsIndex]);
        statsIndex++;
      }
      if (rideStats.showWatchBatteryStatistic) {
        rideStats.statsArray[statsIndex] =
          "Wtch btry: " +
          valueRound(System.getSystemStats().battery, "%.1f").toString() +
          " %";
        //System.println(rideStats.statsArray[statsIndex]);
        statsIndex++;
      }
      if (rideStats.showProfileName) {
        rideStats.statsArray[statsIndex] = "EUC: " + vescData.wheelName;
        //System.println(rideStats.statsArray[statsIndex]);
        statsIndex++;
      }
    }
    WatchUi.requestUpdate();
  }

  function rideStatsInit() {
    rideStats.movingmsec = 0;
    rideStats.statsTimerReset();

    // unelegant
    if (rideStats.showAverageMovingSpeedStatistic) {
      rideStats.statsNumberToDiplay++;
    }
    if (rideStats.showTopSpeedStatistic) {
      rideStats.statsNumberToDiplay++;
    }
    if (rideStats.showWatchBatteryConsumptionStatistic) {
      rideStats.statsNumberToDiplay++;
    }
    if (rideStats.showTotalDistance) {
      rideStats.statsNumberToDiplay++;
    }
    if (rideStats.showTripDistance) {
      rideStats.statsNumberToDiplay++;
    }
    if (rideStats.showVoltage) {
      rideStats.statsNumberToDiplay++;
    }
    if (rideStats.showWatchBatteryStatistic) {
      rideStats.statsNumberToDiplay++;
    }
    if (rideStats.showProfileName) {
      rideStats.statsNumberToDiplay++;
    }
    rideStats.statsArray = new [rideStats.statsNumberToDiplay];
    //System.println("array size:" + rideStats.statsArray.size());
  }
  function setGlobalSettings() {
    vescData.displayData = AppStorage.getSetting("displayData");
    vescData.useMiles = AppStorage.getSetting("useMiles");
    vescData.useFahrenheit = AppStorage.getSetting("useFahrenheit");

    vescData.updateDelay = AppStorage.getSetting("updateDelay");
    vescData.debug = AppStorage.getSetting("debugMode");
    if (vescData.displayData == true) {
      vescData.debug = true;
    }
    vescData.activityAutorecording = AppStorage.getSetting(
      "activityRecordingOnStartup"
    );
    vescData.activityAutosave = AppStorage.getSetting("activitySavingOnExit");

    rideStats.showAverageMovingSpeedStatistic = AppStorage.getSetting(
      "averageMovingSpeedStatistic"
    );
    rideStats.showTopSpeedStatistic =
      AppStorage.getSetting("topSpeedStatistic");

    rideStats.showWatchBatteryConsumptionStatistic = AppStorage.getSetting(
      "watchBatteryConsumptionStatistic"
    );
    rideStats.showTripDistance = AppStorage.getSetting("tripDistanceStatistic");
    rideStats.showTotalDistance = AppStorage.getSetting(
      "totalDistanceStatistic"
    );

    rideStats.showVoltage = AppStorage.getSetting("voltageStatistic");
    rideStats.showWatchBatteryStatistic = AppStorage.getSetting(
      "watchBatteryStatistic"
    );
    rideStats.showProfileName = AppStorage.getSetting("profileName");
  }
}

function getApp() as GarminEUCApp {
  return Application.getApp() as GarminEUCApp;
}
