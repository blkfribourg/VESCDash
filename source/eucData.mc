using Toybox.System;

module eucData {
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
  var DisplayedTemperature = 0.0;
  var maxTemperature = 65;
  var totalDistance = 0.0;
  var correctedTotalDistance = 0.0;
  var PWM = 0.0;
  var pedalMode = "0";
  var speedAlertMode = "0";
  var rollAngleMode = "0";
  var speedUnitMode = 0;
  var ledMode = "0";
  var avgMovingSpeed = 0.0;
  var topSpeed = 0.0;
  var watchBatteryUsage = 0.0;
  var hPWM = 0.0;
  var currentCorrection;
  var gothPWN = false;
  var battery = 0.0;
  // Veteran specific
  var version = 0;

  // Kingsong specific
  var KSName = "";
  var KSSerial;
  var KS18L_scale_toggle = false;
  var mode = 0;
  var fanStatus;
  var chargingStatus;
  var temperature2 = 0;
  var cpuLoad = 0;
  var KSVoiceMode = false;
  // var output;
  var speedLimit = 0;
  var KSMaxSpeed;
  var KSAlarm3Speed;
  var KSAlarm2Speed;
  var KSAlarm1Speed;

  // Kingsong & inmotion :
  var model = "none";

  //inmotion specific
  var imHornSound = 0x18;
  var batteryTemp1 = 0.0;
  var batteryTemp2 = 0.0;

  //VESC :
  var VESCCanId = 0;
  function getBatteryPercentage() {
    // using better battery formula from wheellog

    return battery;
  }

  function getPWM() {
    if (eucData.voltage != 0) {
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
