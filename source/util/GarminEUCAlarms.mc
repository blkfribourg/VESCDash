import Toybox.Attention;
import Toybox.Lang;
using Toybox.System;

module EUCAlarms {
  var alarmDelay = 0;
  var alarmType = "none";
  var PWMAlarm = false;
  var speedAlarm = false;
  var tempAlarm = false;
  function alarmHandler(intensity, duration) {
    Attention.vibrate([new Attention.VibeProfile(intensity, duration)]);
  }
  function setAlarmType() {
    if (PWMAlarm == true) {
      alarmType = "PWM";
    } else {
      if (tempAlarm == true) {
        alarmType = "Temp.";
      } else {
        if (speedAlarm == true) {
          alarmType = "Speed";
        }
      }
    }

    if (PWMAlarm == false && tempAlarm == false && speedAlarm == false) {
      alarmType = "none";
    }
  }
  function speedAlarmCheck() {
    //PWN alarm
    if (Attention has :vibrate && vescData.alarmThreshold_PWM != 0) {
      if (
        vescData.PWM > vescData.alarmThreshold_PWM &&
        vescData.PWM < vescData.alarmThreshold_PWM + 5 &&
        alarmDelay <= 0
      ) {
        EUCAlarms.alarmHandler(100, 300);
        alarmDelay = 1000 / vescData.updateDelay;
        PWMAlarm = true;
      }
      if (vescData.PWM > vescData.alarmThreshold_PWM + 5 && alarmDelay <= 0) {
        EUCAlarms.alarmHandler(100, 100);
        alarmDelay = 200 / vescData.updateDelay;

        PWMAlarm = true;
      }
      if (vescData.PWM < vescData.alarmThreshold_PWM) {
        alarmDelay = 0;

        PWMAlarm = false;
      }
      alarmDelay--;

      setAlarmType();
    }

    //Temperature alarm
    if (Attention has :vibrate && vescData.alarmThreshold_temp != 0) {
      if (
        vescData.DisplayedTemperature > vescData.alarmThreshold_temp &&
        alarmDelay <= 0 &&
        PWMAlarm == false
      ) {
        // PWM alarm have priority over temperature alarm
        EUCAlarms.alarmHandler(100, 300);
        alarmDelay = 1000 / vescData.updateDelay;
        tempAlarm = true;
      }
      if (vescData.DisplayedTemperature < vescData.alarmThreshold_temp) {
        alarmDelay = 0;
        tempAlarm = false;
      } else {
        alarmDelay--;
      }
      setAlarmType();
    }

    //Speed alarm
    if (Attention has :vibrate && vescData.alarmThreshold_speed != 0) {
      if (
        vescData.correctedSpeed > vescData.alarmThreshold_speed &&
        alarmDelay <= 0 &&
        PWMAlarm == false &&
        tempAlarm == false
      ) {
        // PWM alarm and temperature alarm have priority over speed alarm
        EUCAlarms.alarmHandler(100, 300);
        alarmDelay = 1000 / vescData.updateDelay;
        speedAlarm = true;
      }
      if (vescData.correctedSpeed < vescData.alarmThreshold_speed) {
        alarmDelay = 0;
        speedAlarm = false;
      } else {
        alarmDelay--;
      }
      setAlarmType();
    }
  }
}
