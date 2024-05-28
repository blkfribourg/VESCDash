using Toybox.System;
using Toybox.BluetoothLowEnergy as Ble;
using Toybox.WatchUi as Ui;
import Toybox.Lang;
using Toybox.Application.Storage;

class eucBLEDelegate extends Ble.BleDelegate {
  var profileManager = null;
  var device = null;
  var service = null;
  var char = null;
  var service_w = null;
  var char_w = null;
  var queue;
  var decoder = null;
  var isFirst = false;
  private var profileNb;
  var message1 = "";
  var message2 = "";
  var message3 = "";
  var message4 = "";
  var message5 = "";
  var message6 = "";
  var message7 = "";
  var message8 = "";
  var message9 = "";
  var currentState = "";
  var bleCharReadNb = 0;
  var timeWhenConnected;
  var receivedPacket;

  function initialize(pm, _profileNb, q, _decoder) {
    //System.println("init");
    message1 = "initializeBle";
    BleDelegate.initialize();
    profileManager = pm;
    profileNb = _profileNb;
    //char = profileManager.EUC_CHAR;
    queue = q;
    decoder = _decoder;
    currentState = "init";
    /*
    var VESCTestPacket1 = [
      0x02, 0x46, 0x2f, 0x01, 0x29, 0x00, 0xf9, 0x00, 0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    ]b;

    var VESCTestPacket2 = [
      0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0xf0, 0x03, 0xdf, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    ]b;
    var VESCTestPacket3 = [
      0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x70, 0x00, 0x00, 0x00,
      0xea, 0x0a, 0x9f, 0x1d, 0xc0, 0x00, 0x1c, 0x01,
    ]b;
    var VESCTestPacket4 = [
      0x00, 0x08, 0x90, 0xd8, 0x00, 0x06, 0x65, 0xbf, 0x00, 0x02, 0x3e, 0x45,
      0x48, 0xae, 0x03,
    ]b;

    decoder.frameBuilder(self, VESCTestPacket1);
    decoder.frameBuilder(self, VESCTestPacket2);
    decoder.frameBuilder(self, VESCTestPacket3);
    decoder.frameBuilder(self, VESCTestPacket4);

    var ubox1 = [0x02, 0x46]b;
    var ubox2 = [
      0x2f, 0x00, 0xd5, 0xff, 0x14, 0x00, 0x00, 0x00, 0x07, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x06, 0x00, 0x00, 0x00, 0x00, 0x00,
    ]b;
    var ubox3 = [
      0x00, 0x00, 0x00, 0x02, 0x6c, 0x02, 0x56, 0x00, 0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3c, 0x00,
    ]b;
    var ubox4 = [
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x00, 0x00, 0x01, 0x13, 0x00,
      0xdb, 0xb9, 0xfa, 0x00, 0x05, 0x01, 0x00, 0x06,
    ]b;
    var ubox5 = [0x10, 0xb3, 0x00, 0x00, 0x05, 0x6f, 0x00, 0x00, 0xf9, 0xdd]b;
    var ubox6 = [0x6f, 0xc9, 0x03]b;

    decoder.frameBuilder(self, ubox1);
    decoder.frameBuilder(self, ubox2);
    decoder.frameBuilder(self, ubox3);
    decoder.frameBuilder(self, ubox4);
    decoder.frameBuilder(self, ubox5);
    decoder.frameBuilder(self, ubox6);

    var ubox1 = [0x02, 0x46]b;

    var ubox3 = [
      0x2f, 0x00, 0xd3, 0x00, 0xd4, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      0x00, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00,
    ]b;
    var ubox4 = [
      0x00, 0x00, 0x00, 0x01, 0xc9, 0x01, 0xf6, 0x00, 0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    ]b;
    var ubox5 = [
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0a, 0x09,
      0xa7, 0xec, 0x70, 0x00, 0x1a, 0x02, 0x00, 0x04,
    ]b;
    var ubox6 = [0xa1, 0x54, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0xcf, 0x4a]b;

    var ubox7 = [07, 0xb5, 0x03]b;
    decoder.frameBuilder(self, ubox1);

    decoder.frameBuilder(self, ubox3);
    decoder.frameBuilder(self, ubox4);
    decoder.frameBuilder(self, ubox5);
    decoder.frameBuilder(self, ubox6);
    decoder.frameBuilder(self, ubox7);
    /*
    char_w = profileManager.EUC_CHAR_W;
    // VESC COMM VAL SETUP:
    if (vescData.VESCCanId != 0) {
      queue.reqLiveData = [char_w, queue.C_WRITENR, packetForgeVESC(0x2f)];

      queue.sendAlive = [char_w, queue.C_WRITENR, packetForgeVESC(0x1e)];
    } else {
      queue.reqLiveData = [
        char_w,
        queue.C_WRITENR,
        [0x02, 0x01, 0x2f, 0xd5, 0x8d, 0x03]b,
      ];
    }
    queue.UUID = profileManager.EUC_SERVICE;

    queue.delayTimer.start(method(:timerCallback), vescData.BLECmdDelay, true);
    //
*/
    Ble.setScanState(Ble.SCAN_STATE_SCANNING);
    isFirst = isFirstConnection();
  }

  function onConnectedStateChanged(device, state) {
    //		view.deviceStatus=state;
    if (state == Ble.CONNECTION_STATE_CONNECTED) {
      currentState = "BLE connected";
      var cccd;
      service = device.getService(profileManager.EUC_SERVICE);
      char =
        service != null
          ? service.getCharacteristic(profileManager.EUC_CHAR)
          : null;
      if (service != null && char != null) {
        // If KS -> add init seq to ble queue -------- Addition

        char_w = service.getCharacteristic(profileManager.EUC_CHAR_W);
        // VESC COMM VAL SETUP:
        if (vescData.VESCCanId != 0) {
          queue.reqLiveData = [char_w, queue.C_WRITENR, packetForgeVESC(0x2f)];

          // queue.sendAlive = [char_w, queue.C_WRITENR, packetForgeVESC(0x1e)];
        } else {
          queue.reqLiveData = [
            char_w,
            queue.C_WRITENR,
            [0x02, 0x01, 0x2f, 0xd5, 0x8d, 0x03]b,
          ];
        }
        queue.UUID = profileManager.EUC_SERVICE;

        // End of inmotion V2 or VESC
        cccd = char.getDescriptor(Ble.cccdUuid());
        cccd.requestWrite([0x01, 0x00]b);
        message4 = "characteristic notify enabled";
        vescData.paired = true;
        message5 = "BLE paired";
        vescData.timeWhenConnected = new Time.Moment(Time.now().value());

        /* NOT WORKING
        if (device.getName() != null || device.getName().length != 0) {
          vescData.name = device.getName();
        } else {
          vescData.name = "Unknown";
        }*/
      } else {
        message6 = "unable to pair";
        Ble.unpairDevice(device);
        vescData.paired = false;
      }
    } else {
      Ble.unpairDevice(device);
      Ble.setScanState(Ble.SCAN_STATE_SCANNING);
      vescData.paired = false;
    }
  }
  function isFirstConnection() {
    // resetting profileScanResult if wheelName changed :
    if (
      !AppStorage.getSetting("wheelName_p1").equals(
        Storage.getValue("profile1Name")
      )
    ) {
      Storage.deleteValue("profile1Sr");
    }
    if (
      !AppStorage.getSetting("wheelName_p2").equals(
        Storage.getValue("profile2Name")
      )
    ) {
      Storage.deleteValue("profile2Sr");
    }
    if (
      !AppStorage.getSetting("wheelName_p3").equals(
        Storage.getValue("profile3Name")
      )
    ) {
      Storage.deleteValue("profile3Sr");
    }

    if (profileNb == 1 && Storage.getValue("profile1Sr") == null) {
      return true;
    } else if (profileNb == 2 && Storage.getValue("profile2Sr") == null) {
      return true;
    } else if (profileNb == 3 && Storage.getValue("profile3Sr") == null) {
      return true;
    } else {
      return false;
    }
  }

  function storeSR(sr) {
    if (profileNb == 1) {
      Storage.setValue("profile1Sr", sr);
      Storage.setValue("profile1Name", AppStorage.getSetting("wheelName_p1"));
    } else if (profileNb == 2) {
      Storage.setValue("profile2Sr", sr);
      Storage.setValue("profile2Name", AppStorage.getSetting("wheelName_p2"));
    } else if (profileNb == 3) {
      Storage.setValue("profile3Sr", sr);
      Storage.setValue("profile3Name", AppStorage.getSetting("wheelName_p3"));
    }
  }
  function loadSR() {
    if (profileNb == 1) {
      return Storage.getValue("profile1Sr");
    } else if (profileNb == 2) {
      return Storage.getValue("profile2Sr");
    } else if (profileNb == 3) {
      return Storage.getValue("profile3Sr");
    } else {
      return false;
    }
  }
  //! @param scanResults An iterator of new scan results
  function onScanResults(scanResults as Ble.Iterator) {
    currentState = "scanning";
    if (isFirst) {
      var wheelFound = false;
      for (
        var result = scanResults.next();
        result != null;
        result = scanResults.next()
      ) {
        if (result instanceof Ble.ScanResult) {
          var advName = result.getDeviceName();
          if (advName != null) {
            if (knownVESCName(advName) == true) {
              vescData.model = advName;
              wheelFound = true;
            } else {
              wheelFound = contains(
                result.getServiceUuids(),
                profileManager.EUC_SERVICE,
                result
              );
            }
          } else {
            wheelFound = contains(
              result.getServiceUuids(),
              profileManager.EUC_SERVICE,
              result
            );
          }

          if (wheelFound == true) {
            storeSR(result);
            Ble.setScanState(Ble.SCAN_STATE_OFF);
            device = Ble.pairDevice(result as Ble.ScanResult);
          }
        }
      }
    } else {
      Ble.setScanState(Ble.SCAN_STATE_OFF);
      var result = loadSR(); // as Ble.ScanResult;
      if (result != false) {
        device = Ble.pairDevice(result as Ble.ScanResult);
      }
    }
  }

  function timerCallback() {
    queue.run();
  }
  function onDescriptorWrite(desc, status) {
    currentState = "descWrite";
    // If KS fire queue

    if (char != null) {
      queue.delayTimer.start(
        method(:timerCallback),
        vescData.BLECmdDelay,
        true
      );
    }
  }

  function onCharacteristicWrite(desc, status) {}

  function onCharacteristicChanged(char, value) {
    receivedPacket = value;
    currentState = "CharChanged";
    System.println("TX: " + value);
    decoder.frameBuilder(self, value);
  }

  function sendCmd(cmd) {
    //Sys.println("enter sending command " + cmd);

    if (service != null && char != null && cmd != "") {
      var enc_cmd = string_to_byte_array(cmd as String);
      // Sys.println("sending command " + enc_cmd.toString());
      char.requestWrite(enc_cmd, { :writeType => Ble.WRITE_TYPE_DEFAULT });
      //  Sys.println("command sent !");
    }
  }

  function sendRawCmd(cmd) {
    //Sys.println("enter sending command " + cmd);
    char.requestWrite(cmd, { :writeType => Ble.WRITE_TYPE_DEFAULT });
    //  Sys.println("command sent !");
  }

  private function contains(iter, obj, sr) {
    for (var uuid = iter.next(); uuid != null; uuid = iter.next()) {
      if (uuid.equals(obj)) {
        return true;
      }
    }
    return false;
  }

  function getChar() {
    return char;
  }
  function getCharW() {
    return char_w;
  }

  function getPMService() {
    return profileManager.EUC_SERVICE;
  }

  function manualUnpair() {
    if (device != null) {
      try {
        Ble.unpairDevice(device);
      } catch (e instanceof Toybox.Lang.Exception) {
        // System.println(e.getErrorMessage());
      }
    }
  }

  function packetForgeVESC(hexcmd) {
    var cmd = [0x22, vescData.VESCCanId.toNumber(), hexcmd]b;
    var end = CRC16.crc16(cmd);
    end = end.addAll([0x03]b);
    var pre = [0x02, 0x03]b;
    var packet = pre.addAll(cmd);
    packet = packet.addAll(end);
    return packet;
  }
}
