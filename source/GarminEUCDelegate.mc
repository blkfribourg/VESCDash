import Toybox.Lang;
import Toybox.WatchUi;
using Toybox.System;
class GarminEUCDelegate extends WatchUi.BehaviorDelegate {
  var eucBleDelegate = null;
  var queue = null;
  var menu = null;
  var mainView = null;
  var activityView = null;
  var DFlikeView = null;
  var menu2Delegate = null;
  var actionButtonTrigger = null;

  function initialize(
    main_view,
    _menu2,
    _menu2Delegate,
    current_eucBleDelegate,
    q,
    _activityView,
    _actionButtonTrigger
  ) {
    eucBleDelegate = current_eucBleDelegate;
    queue = q;
    menu = _menu2;
    menu2Delegate = _menu2Delegate;
    BehaviorDelegate.initialize();
    mainView = main_view;
    activityView = _activityView;
    actionButtonTrigger = _actionButtonTrigger;
  }

  function onMenu() as Boolean {
    WatchUi.pushView(menu, menu2Delegate, WatchUi.SLIDE_UP);
    return true;
  }

  function onSwipe(swipeEvent as WatchUi.SwipeEvent) {
    if (swipeEvent.getDirection() == WatchUi.SWIPE_UP) {
      goToActivityView();
    }
    if (swipeEvent.getDirection() == WatchUi.SWIPE_LEFT) {
    }
    return true;
  }

  function onNextPage() as Boolean {
    return false;
  }

  function onKey(keyEvent as WatchUi.KeyEvent) {
    actionButtonTrigger.triggerAction(
      eucBleDelegate,
      keyEvent.getKey(),
      self,
      queue
    );

    if (keyEvent.getKey().equals(WatchUi.KEY_ESC)) {
      var message = "Exit VESCDash?";
      var dialog = new WatchUi.Confirmation(message);
      var confirmDelegate = new MyConfirmationDelegate();
      WatchUi.pushView(dialog, confirmDelegate, WatchUi.SLIDE_IMMEDIATE);
    }

    return true;
  }

  function getActivityView() {
    return activityView;
  }
  function unpair() {
    eucBleDelegate.manualUnpair();
  }

  function goToActivityView() {
    //System.println("bringing activity view");
    WatchUi.pushView(
      activityView,
      new ActivityRecordDelegate(activityView),
      WatchUi.SLIDE_UP
    ); // Switch to activity view
  }
  /*
  function goToDFlikeView() {
    DFlikeView = new DFView();

    WatchUi.pushView(DFlikeView, self, WatchUi.SLIDE_UP);
  }*/
  function getMenu2Delegate() {
    return menu2Delegate;
  }
}

class MyConfirmationDelegate extends WatchUi.ConfirmationDelegate {
  function initialize() {
    ConfirmationDelegate.initialize();
  }

  function onResponse(response) {
    if (response == WatchUi.CONFIRM_YES) {
      System.exit();
    }
    return true;
  }
}
