import Toybox.WatchUi;
import Toybox.System;

class BackgroundRenderer extends WatchUi.Drawable {
  private var bg;
  function initialize(params) {
    Drawable.initialize(params);

    if (!vescData.limitedMemory) {
      bg = Application.loadResource(Rez.Drawables.BackgroundImg);
    }
  }
  function getXY(screenDiam, startingAngle, radius, angle, pos) {
    var x =
      screenDiam / 2 -
      radius * Math.sin(Math.toRadians(startingAngle - angle * pos));
    var y =
      screenDiam / 2 -
      radius * Math.cos(Math.toRadians(startingAngle - angle * pos));
    return [x, y];
  }
  function draw(dc) {
    var screenDiam = dc.getWidth();
    dc.setColor(0x000000, 0x000000);

    if (!vescData.limitedMemory) {
      dc.drawBitmap(0, 0, bg);
    } else {
      var startingAngle = 120;
      var batStartingAngle = 120;
      var MtickNb = 10;
      var mtickNb = 50;
      var tempStartingAngle = 332;
      var tempMtickFactor = 0.26;
      var tempmtickFactor = 0.28;
      var tempMtickAngle = 36;
      var tempmtickAngle = 18;
      if (screenDiam == 176) {
        MtickNb = 5;
        mtickNb = 25;
        batStartingAngle = 90;
        tempStartingAngle = 270;
        tempMtickFactor = 0.38;
        tempmtickFactor = 0.4;
        tempMtickAngle = 22;
        tempmtickAngle = 11;
      }
      dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
      dc.clear();
      // red zone
      dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
      dc.setPenWidth(9);
      dc.drawArc(
        screenDiam / 2,
        screenDiam / 2,
        0.47 * screenDiam,
        Graphics.ARC_CLOCKWISE,
        18,
        330
      );
      dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
      dc.setPenWidth(2);

      for (var majorTick = 0; majorTick < MtickNb + 1; majorTick++) {
        var startCoord = getXY(
          screenDiam,
          startingAngle,
          0.46 * screenDiam,
          24,
          majorTick
        );
        var endCoord = getXY(
          screenDiam,
          startingAngle,
          0.49 * screenDiam,
          24,
          majorTick
        );
        dc.drawLine(startCoord[0], startCoord[1], endCoord[0], endCoord[1]);
      }
      for (var majorBtrTick = 0; majorBtrTick < 3; majorBtrTick++) {
        var startCoord = getXY(
          screenDiam,
          batStartingAngle,
          0.26 * screenDiam,
          36,
          majorBtrTick
        );
        var endCoord = getXY(
          screenDiam,
          batStartingAngle,
          0.29 * screenDiam,
          36,
          majorBtrTick
        );
        dc.drawLine(startCoord[0], startCoord[1], endCoord[0], endCoord[1]);
      }
      for (var majorTempTick = 0; majorTempTick < 3; majorTempTick++) {
        var startCoord = getXY(
          screenDiam,
          tempStartingAngle,
          tempMtickFactor * screenDiam,
          tempMtickAngle,
          majorTempTick
        );
        var endCoord = getXY(
          screenDiam,
          tempStartingAngle,
          (tempMtickFactor + 0.03) * screenDiam,
          tempMtickAngle,
          majorTempTick
        );
        dc.drawLine(startCoord[0], startCoord[1], endCoord[0], endCoord[1]);
      }
      dc.setPenWidth(1);
      for (var minorTick = 0; minorTick < mtickNb + 1; minorTick++) {
        var startCoord = getXY(
          screenDiam,
          startingAngle,
          0.46 * screenDiam,
          4.8,
          minorTick
        );
        var endCoord = getXY(
          screenDiam,
          startingAngle,
          0.49 * screenDiam,
          4.8,
          minorTick
        );
        dc.drawLine(startCoord[0], startCoord[1], endCoord[0], endCoord[1]);
      }
      for (var minorBtrTick = 0; minorBtrTick < 5; minorBtrTick++) {
        var startCoord = getXY(
          screenDiam,
          batStartingAngle,
          0.28 * screenDiam,
          18,
          minorBtrTick
        );
        var endCoord = getXY(
          screenDiam,
          batStartingAngle,
          0.29 * screenDiam,
          18,
          minorBtrTick
        );
        dc.drawLine(startCoord[0], startCoord[1], endCoord[0], endCoord[1]);
      }
      for (var minorTempTick = 0; minorTempTick < 5; minorTempTick++) {
        var startCoord = getXY(
          screenDiam,
          tempStartingAngle,
          tempmtickFactor * screenDiam,
          tempmtickAngle,
          minorTempTick
        );
        var endCoord = getXY(
          screenDiam,
          tempStartingAngle,
          (tempmtickFactor + 0.01) * screenDiam,
          tempmtickAngle,
          minorTempTick
        );
        dc.drawLine(startCoord[0], startCoord[1], endCoord[0], endCoord[1]);
      }
    }
  }
}
