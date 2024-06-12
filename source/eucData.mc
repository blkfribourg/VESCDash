using Toybox.System;

module vescData {
  var wheelName;
  var paired = false;
  var limitedMemory = false;
  // Calculated PWM variables :
  // PLEASE UPDATE WITH YOU OWN VALUES BEFORE USE !
  var rotationSpeed; // cutoff speed when freespin test performed
  var powerFactor; // 0.9 for better safety
  var rotationVoltage; // voltage when freespin test performed
  var updateDelay = 200; // UI refresh every updateDelay
  var BLECmdDelay = 200;
  var topBar; // String : Speed or PWM
  var mainNumber; // String : Speed or PWM
  var maxDisplayedSpeed; // number, used if topBar equals Speed : read from settings
  var alarmThreshold_PWM;
  var alarmThreshold_speed;
  var alarmThreshold_temp;
  var activityAutorecording;
  var activityAutosave;
  var activityRecording = false;
  var debug;
  var BLEReadRate = 0;
  var timeWhenConnected;
  //UI
  var sagThreshold = 0.3;
  var orangeColoringThreshold;
  var redColoringThreshold;

  var logoColor = 0x1f1f1f;
  var txtColor = 0xffffff;
  var txtColor_unpr = 0xff8000;
  var linesColor = 0xffffff;
  var drawLines = true;

  var speedCorrectionFactor = 1; // correct distance aswell ...
  var useMiles = false;
  var useFahrenheit = false;
  var deviceName = null;
  var voltage_scaling = 1;
  var speed = 0.0;
  var correctedSpeed = 0.0;
  var voltage = 0.0;
  var lowestBatteryPercentage = 101;
  var tripDistance = 0.0;
  var correctedTripDistance = 0.0;
  var Phcurrent = 0.0;
  var current = 0.0;
  var temperature = 0.0;
  var temperature_motor = 0.0;
  var DisplayedTemperature = 0.0;
  var maxTemperature = 65;
  var totalDistance = 0.0;
  var correctedTotalDistance = 0.0;
  var PWM = 0.0;
  var rpm;

  var avgMovingSpeed = 0.0;
  var topSpeed = 0.0;
  var watchBatteryUsage = 0.0;
  var hPWM = 0.0;
  var currentCorrection;
  var model = "";

  var battery = 0.0;
  var amp_hours;
  var amp_hours_charged;
  var watt_hours;
  var watt_hours_charged;
  var tachometer;
  var tachometer_abs;
  var position;
  var fault_code;
  var fault_str;
  var vesc_id;
  var num_vescs;
  var battery_wh;
  var uptime_ms;

  //VESC :
  var VESCCanId = 0;
  var displayData = false;

  var displayWind;
  var displayNorth;

  function getBatteryPercentage() {
    // using better battery formula from wheellog

    return battery;
  }

  function getPWM() {
    if (vescData.voltage != 0) {
      return hPWM;
    } else {
      return 0.0;
    }
  }
  function getCurrent() {
    return current;
  }
  function getCorrectedSpeed() {
    if (useMiles == true) {
      return speed * speedCorrectionFactor.toFloat() * 0.621371192;
    } else {
      return speed * speedCorrectionFactor.toFloat();
    }
  }
  function getCorrectedTripDistance() {
    if (useMiles == true) {
      return tripDistance * speedCorrectionFactor.toFloat() * 0.621371192;
    } else {
      return tripDistance * speedCorrectionFactor.toFloat();
    }
  }
  function getCorrectedTotalDistance() {
    if (useMiles == true) {
      return totalDistance * speedCorrectionFactor.toFloat() * 0.621371192;
    } else {
      return totalDistance * speedCorrectionFactor.toFloat();
    }
  }
  function getTemperature() {
    if (useFahrenheit == true) {
      return temperature * 1.8 + 32.0;
    } else {
      return temperature;
    }
  }

  function getVoltage() {
    return voltage;
  }
}
