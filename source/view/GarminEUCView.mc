import Toybox.Graphics;
import Toybox.WatchUi;
using Toybox.Timer;

using Toybox.System;

class GarminEUCView extends WatchUi.View {
  private var cDrawables = {};
  function initialize() {
    View.initialize();
  }

  function onLayout(dc as Dc) as Void {
    setLayout(Rez.Layouts.HomeLayout(dc));

    // Label drawables
    cDrawables[:TimeDate] = View.findDrawableById("TimeDate");
    cDrawables[:SpeedNumber] = View.findDrawableById("SpeedNumber");
    cDrawables[:BatteryNumber] = View.findDrawableById("BatteryNumber");
    cDrawables[:TemperatureNumber] = View.findDrawableById("TemperatureNumber");
    cDrawables[:BottomSubtitle] = View.findDrawableById("BottomSubtitle");
    // And arc drawables
    cDrawables[:SpeedArc] = View.findDrawableById("SpeedDial"); // used for PMW
    cDrawables[:BatteryArc] = View.findDrawableById("BatteryArc");
    cDrawables[:TemperatureArc] = View.findDrawableById("TemperatureArc");
    cDrawables[:RecordingIndicator] =
      View.findDrawableById("RecordingIndicator");
  }

  // Called when this View is brought to the foreground. Restore
  // the state of this View and prepare it to be shown. This includes
  // loading resources into memory.
  function onShow() {
    var CurrentTime = System.getClockTime();
    cDrawables[:TimeDate].setText(
      CurrentTime.hour.format("%d") + ":" + CurrentTime.min.format("%02d")
    );

    cDrawables[:TimeDate].setColor(Graphics.COLOR_WHITE);
  }

  // Update the view
  function onUpdate(dc) {
    // Update label drawables
    cDrawables[:TimeDate].setText(
      // Update time
      System.getClockTime().hour.format("%d") +
        ":" +
        System.getClockTime().min.format("%02d")
    );
    var batteryPercentage = vescData.getBatteryPercentage();

    cDrawables[:BatteryNumber].setText(
      valueRound(batteryPercentage, "%.1f") + "%"
    );
    var tempUnit;
    if (vescData.useFahrenheit == true) {
      tempUnit = "°F";
    } else {
      tempUnit = "°C";
    }
    cDrawables[:TemperatureNumber].setText(
      valueRound(vescData.DisplayedTemperature, "%.1f").toString() + tempUnit
    );
    cDrawables[:BottomSubtitle].setText(diplayStats());
    /* To implement later
            switch (AppStorage.getSetting("BottomSubtitleData")) {
                case 0: cDrawables[:BottomSubtitle].setText(WheelData.wheelModel); break;
                case 1: cDrawables[:BottomSubtitle].setText(Lang.format("$1$% / $2$%", [WheelData.pwm, WheelData.maxPwm])); break;
                case 2: cDrawables[:BottomSubtitle].setText(Lang.format("$1$ / $2$", [WheelData.averageSpeed, WheelData.topSpeed])); break;
                case 3: cDrawables[:BottomSubtitle].setText(WheelData.rideTime); break;
                case 4: cDrawables[:BottomSubtitle].setText(WheelData.rideDistance.toString()); break;
            }
        */

    var speedNumberStr = "";

    if (vescData.mainNumber == 0) {
      var speedNumberVal = "";
      speedNumberVal = vescData.correctedSpeed;
      if (speedNumberVal >= 100) {
        speedNumberStr = valueRound(vescData.correctedSpeed, "%d").toString();
      } else {
        speedNumberStr = valueRound(vescData.correctedSpeed, "%.1f").toString();
      }
    }
    if (vescData.mainNumber == 1) {
      var speedNumberVal;
      speedNumberVal = vescData.PWM;
      if (speedNumberVal >= 100) {
        speedNumberStr = valueRound(vescData.PWM, "%d").toString();
      } else {
        speedNumberStr = valueRound(vescData.PWM, "%.1f").toString();
      }
    }
    if (vescData.mainNumber == 2) {
      var speedNumberVal;
      speedNumberVal = vescData.getBatteryPercentage();
      if (speedNumberVal > 100) {
        speedNumberStr = valueRound(speedNumberVal, "%d").toString();
      } else {
        speedNumberStr = valueRound(speedNumberVal, "%.1f").toString();
      }
    }
    cDrawables[:SpeedNumber].setText(speedNumberStr);
    //cDrawables[:SpeedArc].setValues(WheelData.currentSpeed.toFloat(), WheelData.speedLimit);
    if (vescData.topBar == 0) {
      cDrawables[:SpeedArc].setValues(vescData.PWM.toFloat(), 100);
    } else {
      cDrawables[:SpeedArc].setValues(
        vescData.correctedSpeed.toFloat(),
        vescData.maxDisplayedSpeed
      );
    }

    cDrawables[:BatteryArc].setValues(batteryPercentage, 100);
    cDrawables[:TemperatureArc].setValues(
      vescData.DisplayedTemperature,
      vescData.maxTemperature
    );
    cDrawables[:TimeDate].setColor(Graphics.COLOR_WHITE);
    cDrawables[:SpeedNumber].setColor(Graphics.COLOR_WHITE);
    cDrawables[:BatteryNumber].setColor(Graphics.COLOR_WHITE);
    cDrawables[:TemperatureNumber].setColor(Graphics.COLOR_WHITE);
    cDrawables[:BottomSubtitle].setColor(Graphics.COLOR_WHITE);

    // Call the parent onUpdate function to redraw the layout
    View.onUpdate(dc);
  }

  function diplayStats() {
    //System.println(EUCAlarms.alarmType);
    var rideStatsText = "";
    if (!vescData.paired) {
      rideStatsText = "VESC Not\nConnected";
    } else {
      if (!EUCAlarms.alarmType.equals("none")) {
        rideStatsText = "!! Alarm: " + EUCAlarms.alarmType + " !!";
      } else {
        if (
          rideStats.statsArray != null &&
          rideStats.statsNumberToDiplay != 0
        ) {
          rideStatsText = rideStats.statsArray[rideStats.statsIndexToDiplay];

          rideStats.statsTimer--;
          if (rideStats.statsTimer < 0) {
            rideStats.statsIndexToDiplay++;
            rideStats.statsTimerReset();
            if (
              rideStats.statsIndexToDiplay >
              rideStats.statsNumberToDiplay - 1
            ) {
              rideStats.statsIndexToDiplay = 0;
            }
          }
        }
      }
    }
    //Sanity check, may return null during app initialization
    if (rideStatsText != null) {
      return rideStatsText;
    } else {
      return "";
    }
  }

  // Called when this View is removed from the screen. Save the
  // state of this View here. This includes freeing resources from
  // memory.
  function onHide() as Void {}
}
