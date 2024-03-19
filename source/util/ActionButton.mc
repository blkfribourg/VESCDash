import Toybox.System;
import Toybox.WatchUi;
import Toybox.Lang;
class ActionButton {
  var eucDict;
  var lightToggleIndex = 0;
  //var lockStatus = 0;
  var recordActivityButton;
  var cycleLightButton;
  var beepButton;
  var DFViewButton;
  //var lockButton;
  var queue;
  var queueRequired;
  function setEUCDict() {
    eucDict = getEUCSettingsDict();
  }
  function triggerAction(bleDelegate, keyNumber, _mainDelegate, _queue) {
    if (eucData.paired == true) {
      queueRequired = false;
      queue = _queue;

      if (recordActivityButton == keyNumber) {
        _mainDelegate.goToActivityView();
      }

      if (DFViewButton == keyNumber){
        _mainDelegate.goToDFlikeView();
      }
      //if (bleDelegate != null && eucData.paired == true) {
      if (cycleLightButton == keyNumber) {
        queueRequired = true;
        // Action = cycle light modes
      }
      if (beepButton == keyNumber) {
        queueRequired = true;
        // Action = beep beep
      }
      //}
      if (queueRequired == true) {
        queue.delayTimer.start(
          method(:timerCallback),
          eucData.BLECmdDelay,
          true
        );
      }
    }
  }

  function timerCallback() {
    queue.run();
  }
}
