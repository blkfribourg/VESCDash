import Toybox.WatchUi;
import Toybox.Application.Properties;
import Toybox.Application.Storage;
import Toybox.System;

class RecordIndicatorRenderer extends WatchUi.Drawable {
  private var mMainColor;
  private var screenWidth = System.getDeviceSettings().screenWidth;
  private var pause = 1000;
  function initialize(params) {
    Drawable.initialize(params);
    mMainColor = params.get(:mainColor);
  }
  function draw(dc) {
    if (vescData.activityRecording == true) {
      //System.println(pause);
      var foregroundColor;
      if (pause < 0) {
        foregroundColor = 0x000000;
      } else {
        foregroundColor = mMainColor;
      }
      dc.setPenWidth(2);
      dc.setColor(foregroundColor, 0x000000);
      dc.fillCircle(screenWidth / 2, screenWidth * 0.715, screenWidth / 70);
      dc.drawCircle(screenWidth / 2, screenWidth * 0.715, screenWidth / 40);
      pause = pause - vescData.updateDelay;
      if (pause < -1000) {
        pause = 1000;
      }
    }
  }
}

class ArcRenderer extends WatchUi.Drawable {
  private var mMainColor,
    mSecondColor,
    mThirdColor,
    mStartDegree,
    mEndDegree,
    mXCenterPosition,
    mYCenterPosition,
    mArcRadius,
    mArcSize,
    mArcDirection,
    mArcType,
    mDataDrawingDirection;

  var currentValue = 0,
    maxValue = 0;
  private var screenCenterX = System.getDeviceSettings().screenWidth / 2;
  private var screenCenterY = System.getDeviceSettings().screenHeight / 2;

  private var screenHeight = System.getDeviceSettings().screenHeight;
  private var screenWidth = System.getDeviceSettings().screenWidth;

  function initialize(params) {
    Drawable.initialize(params);

    mArcType = params[:arcType];
    mMainColor = params.get(:mainColor);
    mSecondColor = params.get(:secondColor);
    if (mArcType != :batteryArc) {
      mThirdColor = params[:thirdColor];
    }
    mStartDegree = params.get(:startDegree);
    mEndDegree = params.get(:endDegree);
    if (params.get(:xCenterPosition) == :center) {
      mXCenterPosition = screenCenterX;
    } else {
      mXCenterPosition = params.get(:xCenterPosition);
    }

    if (params.get(:yCenterPosition) == :center) {
      mYCenterPosition = screenCenterY;
    } else {
      mYCenterPosition = params.get(:yCenterPosition);
    }

    if (params.get(:arcRadius) == :max) {
      mArcRadius = screenWidth / 2;
    } else {
      mArcRadius = params.get(:arcRadius);
    }
    mArcSize = params.get(:arcSize);
    mArcDirection = params[:arcDirection];
    mDataDrawingDirection = params.get(:dataDrawingDirection);
  }

  function draw(dc) {
    var backgroundColor = 0x333333;
    dc.setPenWidth(mArcSize);

    var foregroundColor;

    dc.setColor(backgroundColor, 0x000000);
    dc.drawArc(
      mXCenterPosition,
      mYCenterPosition,
      mArcRadius,
      Graphics.ARC_CLOCKWISE,
      mStartDegree,
      mEndDegree
    );

    switch (mArcType) {
      case :speedArc: {
        if (currentValue != 0.0) {
          if (
            //should move appstorage values elsewhere
            currentValue >= vescData.orangeColoringThreshold &&
            currentValue < vescData.redColoringThreshold
          ) {
            foregroundColor = mSecondColor;
          } else if (currentValue >= vescData.redColoringThreshold) {
            foregroundColor = mThirdColor;
          } else {
            foregroundColor = mMainColor;
          }
        } else {
          foregroundColor = mMainColor;
        }
        if (vescData.paired == false) {
          foregroundColor = 0x545454;
        }
        dc.setColor(foregroundColor, 0x000000);
        if (currentValue >= maxValue) {
          dc.drawArc(
            mXCenterPosition,
            mYCenterPosition,
            mArcRadius,
            Graphics.ARC_CLOCKWISE,
            mStartDegree,
            mEndDegree
          );
        } else {
          var degreeRange = mStartDegree - mEndDegree;

          var percentage = currentValue.toFloat() / maxValue.toFloat();
          var preResult = degreeRange * percentage;
          var result = mStartDegree - preResult;
          if (result != mStartDegree) {
            dc.drawArc(
              mXCenterPosition,
              mYCenterPosition,
              mArcRadius,
              mArcDirection,
              mStartDegree,
              result
            );
          }
        }

        break;
      }
      case :batteryArc: {
        // if no sag value :
        var batteryPercentage = vescData.getBatteryPercentage();
        // BatterySag, move elsewhere ?
        if (vescData.lowestBatteryPercentage > batteryPercentage.toNumber()) {
          vescData.lowestBatteryPercentage = batteryPercentage.toNumber();
        }

        if (currentValue >= maxValue) {
          if (vescData.paired == false) {
            foregroundColor = 0x545454;
          } else {
            foregroundColor = mMainColor;
          }

          dc.setColor(foregroundColor, 0x000000);
          dc.drawArc(
            mXCenterPosition,
            mYCenterPosition,
            mArcRadius,
            Graphics.ARC_CLOCKWISE,
            mStartDegree,
            mEndDegree
          );
        } else {
          //System.println(computedPercentageLoadDrop);

          if (vescData.paired == false) {
            foregroundColor = 0x545454;
          } else {
            foregroundColor = mMainColor;
          }
          dc.setColor(foregroundColor, 0x000000);
          // Render green arc
          var degreeRange = mStartDegree - mEndDegree;
          var secondPercentage = currentValue.toFloat() / maxValue.toFloat();
          var secondResult =
            degreeRange - degreeRange * secondPercentage + mEndDegree;
          if (secondResult != mStartDegree) {
            dc.drawArc(
              mXCenterPosition,
              mYCenterPosition,
              mArcRadius,
              mArcDirection,
              mStartDegree,
              secondResult
            );
          }

          if (
            currentValue != 0 &&
            1 - vescData.lowestBatteryPercentage / currentValue >
              vescData.sagThreshold
          ) {
            if (vescData.paired == false) {
              foregroundColor = 0x545454;
            } else {
              foregroundColor = mSecondColor;
            }

            dc.setColor(foregroundColor, 0x000000);
            // Render yellow arc

            var percentage =
              vescData.lowestBatteryPercentage.toFloat() / maxValue.toFloat();
            var result = degreeRange - degreeRange * percentage + mEndDegree;
            if (result != mStartDegree) {
              //draw a line instead of an arc fill :
              dc.setColor(mSecondColor, 0x000000);
              dc.drawArc(
                mXCenterPosition,
                mYCenterPosition,
                mArcRadius,
                mArcDirection,
                mStartDegree,
                result
                //result - 1
              );
            }
          }
        }
        break;
      }
      case :temperatureArc: {
        if (currentValue != 0.0) {
          //System.println(WheelData.temperature.toNumber());
          //System.println(currentValue);
          if (
            currentValue >= 0.75 * vescData.maxTemperature &&
            currentValue < 0.8 * vescData.maxTemperature
          ) {
            foregroundColor = mSecondColor;
            //System.println("secondColor");
          } else if (currentValue > 0.8 * vescData.maxTemperature) {
            foregroundColor = mThirdColor;
            //System.println("thirdColor");
          } else {
            foregroundColor = mMainColor;
            //System.println("mainColor");
          }
        } else {
          foregroundColor = mMainColor;
          //System.println("mainColor");
        }
        if (vescData.paired == false) {
          foregroundColor = 0x545454;
        }
        dc.setColor(foregroundColor, 0x000000);

        if (currentValue >= maxValue) {
          dc.drawArc(
            mXCenterPosition,
            mYCenterPosition,
            mArcRadius,
            Graphics.ARC_CLOCKWISE,
            mStartDegree,
            mEndDegree
          );
        } else {
          var degreeRange = mStartDegree.abs() + mEndDegree.abs();
          var percentage = currentValue.toFloat() / maxValue.toFloat();
          var preResult = degreeRange * percentage;
          var result = preResult + mEndDegree;
          if (result != mEndDegree) {
            dc.drawArc(
              mXCenterPosition,
              mYCenterPosition,
              mArcRadius,
              mArcDirection,
              mEndDegree,
              result
            );
          }
        }
        break;
      }
    }
  }

  function setValues(current, max) {
    currentValue = current;
    maxValue = max;
  }
}
