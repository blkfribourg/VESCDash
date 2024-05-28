import Toybox.Graphics;
import Toybox.WatchUi;
using Toybox.Timer;

using Toybox.System;
class GarminEUCDebugView extends WatchUi.View {
  var BleDelegate;
  function initialize() {
    View.initialize();
  }
  function setBleDelegate(_BleDelegate) {
    BleDelegate = _BleDelegate;
  }

  // Called when this View is brought to the foreground. Restore
  // the state of this View and prepare it to be shown. This includes
  // loading resources into memory.
  function onShow() {}

  // Update the view
  function onUpdate(dc) {
    if (BleDelegate != null) {
      if (vescData.displayData == true) {
        var alignAxe = dc.getWidth() / 5;
        var space = dc.getHeight() / 10;
        var yGap = dc.getHeight() / 8;
        var xGap = dc.getWidth() / 12;
        var line1 = "";
        var line2 = "";
        var line3 = "";
        if (BleDelegate.receivedPacket != null) {
          if (BleDelegate.receivedPacket.size() > 0) {
            for (var i = 0; i < BleDelegate.receivedPacket.size(); i++) {
              if (i < 8) {
                if (i == 7) {
                  line1 = line1 + BleDelegate.receivedPacket[i].format("%x");
                } else {
                  line1 =
                    line1 + BleDelegate.receivedPacket[i].format("%x") + " ";
                }
              }
              if (i >= 8 && i < 16) {
                if (i == 15) {
                  line2 = line2 + BleDelegate.receivedPacket[i].format("%x");
                } else {
                  line2 =
                    line2 + BleDelegate.receivedPacket[i].format("%x") + " ";
                }
              }
              if (i >= 16) {
                if (i == BleDelegate.receivedPacket.size() - 1) {
                  line3 = line3 + BleDelegate.receivedPacket[i].format("%x");
                } else {
                  line3 =
                    line3 + BleDelegate.receivedPacket[i].format("%x") + " ";
                }
              }
            }
          }
        }

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawText(
          alignAxe,
          yGap,
          Graphics.FONT_TINY,
          "Received data:",
          Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );
        dc.drawText(
          alignAxe - xGap,
          space + yGap,
          Graphics.FONT_XTINY,
          line1,
          Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );
        dc.drawText(
          alignAxe - xGap,
          2 * space + yGap,
          Graphics.FONT_XTINY,
          line2,
          Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );
        dc.drawText(
          alignAxe - xGap,
          3 * space + yGap,
          Graphics.FONT_XTINY,
          line3,
          Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );
      } else {
        var alignAxe = dc.getWidth() / 5;
        var space = dc.getHeight() / 10;
        var yGap = dc.getHeight() / 8;
        var xGap = dc.getWidth() / 12;

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawText(
          alignAxe,
          yGap,
          Graphics.FONT_TINY,
          "Spd: " + valueRound(vescData.speed, "%.1f"),
          Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );
        dc.drawText(
          alignAxe - xGap,
          space + yGap,
          Graphics.FONT_TINY,
          "Vlt: " + valueRound(vescData.voltage, "%.1f"),
          Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );
        dc.drawText(
          alignAxe - 2 * xGap,
          2 * space + yGap,
          Graphics.FONT_TINY,
          "Cur: " + valueRound(vescData.current, "%.1f"),
          Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );
        dc.drawText(
          alignAxe - 2 * xGap,
          3 * space + yGap,
          Graphics.FONT_TINY,
          "bat%: " + valueRound(vescData.getBatteryPercentage(), "%.1f"),
          Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );
        dc.drawText(
          alignAxe - 2 * xGap,
          4 * space + yGap,
          Graphics.FONT_TINY,
          "tDist: " + valueRound(vescData.totalDistance, "%.1f"),
          Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );
        dc.drawText(
          alignAxe - 2 * xGap,
          5 * space + yGap,
          Graphics.FONT_TINY,
          "PWM: " + valueRound(vescData.hPWM, "%.1f"),
          Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );
        dc.drawText(
          alignAxe - xGap,
          6 * space + yGap,
          Graphics.FONT_TINY,
          "data/s: " + valueRound(vescData.BLEReadRate, "%.1f"),
          Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );
        dc.drawText(
          alignAxe,
          7 * space + yGap,
          Graphics.FONT_TINY,
          "runId: " + BleDelegate.queue.run_id,
          Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );
        dc.drawText(
          2 * alignAxe + xGap / 2,
          2 * space + yGap,
          Graphics.FONT_TINY,
          "bleSt: " + BleDelegate.currentState,
          Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );
      }
    }

    /*
    if (vescData.wheelBrand == 3) {
      if (BleDelegate != null) {
        var alignAxe = dc.getWidth() / 5;
        var space = dc.getHeight() / 10;
        var yGap = dc.getHeight() / 8;
        var xGap = dc.getWidth() / 12;
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawRectangle(0, 0, dc.getWidth(), dc.getHeight());
        dc.drawText(
          alignAxe,
          yGap,
          Graphics.FONT_XTINY,
          BleDelegate.message1,
          Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );
        dc.drawText(
          alignAxe - xGap,
          space + yGap,
          Graphics.FONT_XTINY,
          BleDelegate.message2,
          Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );
        dc.drawText(
          alignAxe - 2 * xGap,
          2 * space + yGap,
          Graphics.FONT_XTINY,
          BleDelegate.message3,
          Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );
        dc.drawText(
          alignAxe - 2 * xGap,
          3 * space + yGap,
          Graphics.FONT_XTINY,
          BleDelegate.message4,
          Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );
        dc.drawText(
          alignAxe - 2 * xGap,
          4 * space + yGap,
          Graphics.FONT_XTINY,
          BleDelegate.message5,
          Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );
        dc.drawText(
          alignAxe - 2 * xGap,
          5 * space + yGap,
          Graphics.FONT_XTINY,
          BleDelegate.message6,
          Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );
        dc.drawText(
          alignAxe - xGap,
          6 * space + yGap,
          Graphics.FONT_XTINY,
          BleDelegate.message7,
          Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );
        dc.drawText(
          alignAxe,
          7 * space + yGap,
          Graphics.FONT_XTINY,
          BleDelegate.message8,
          Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );
        dc.drawText(
          alignAxe + xGap,
          8 * space + yGap,
          Graphics.FONT_XTINY,
          BleDelegate.message9,
          Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );
      }
    }*/
  }
}
