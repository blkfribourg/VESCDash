import Toybox.Lang;
import Toybox.System;
module rideStats {
  var showAverageMovingSpeedStatistic;
  var showTopSpeedStatistic;
  var showWatchBatteryConsumptionStatistic;
  var showTripDistance;
  var showTotalDistance;
  var showVoltage;
  var showWatchBatteryStatistic;
  var statsNumberToDiplay = 0;
  var statsIndexToDiplay = 0;
  var statsArray;
  var minimalMovingSpeed = 3.0; // 3 kmh erased in GarminEUCApp
  var distanceSinceStartup;
  var startupDistance as Float?;
  var movingmsec = 0.0;
  var runningmsec = 0.0;
  var statsTimer;
  var consummedWatchBattery = 0.0;
  var startupWatchBattery;
  var showProfileName;

  function avgSpeed() {
    if (vescData.useMiles == false) {
      minimalMovingSpeed = 2; // 2 mph
    } else {
      minimalMovingSpeed = 3; // 3 km/h
    }
    if (vescData.correctedSpeed > minimalMovingSpeed) {
      if (startupDistance == null) {
        startupDistance = vescData.correctedTripDistance;
      }
      movingmsec = movingmsec + vescData.updateDelay;
      vescData.avgMovingSpeed =
        (vescData.correctedTripDistance - startupDistance) /
        (movingmsec / 3600000.0);
    }
  }

  function topSpeed() {
    if (vescData.correctedSpeed > vescData.topSpeed) {
      vescData.topSpeed = vescData.correctedSpeed;
    }
  }

  function watchBatteryUsage() {
    runningmsec = runningmsec + vescData.updateDelay;
    if (startupWatchBattery == null) {
      startupWatchBattery = System.getSystemStats().battery;
    }
    consummedWatchBattery =
      startupWatchBattery - System.getSystemStats().battery;
    vescData.watchBatteryUsage =
      consummedWatchBattery / (runningmsec / 3600000.0);
  }

  function statsTimerReset() {
    statsTimer = 2000.0 / vescData.updateDelay;
  }
}
